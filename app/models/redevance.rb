class Redevance < PaymentRecord
    validates :ticket_number, uniqueness: true, allow_blank: true

    def notification_data
        {
            msisdn: self.msisdn,
            identifiant: self.declarant_code,
            id_transaction: self.payment_trnx_ref,
            montant: self.amount
        }
    end

    def self.filter_columns
        %w[transaction_id msisdn payment_trnx_ref]
      end
    
      # function to determine all transactions for a day
      def self.today_transactions(key:)
        params = {created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day}
        if [:failure, :success].include?(key)
            where(params.merge(status: key))
        else
            where(params.merge(status: [:pending, :failure, :success]))
        end
        
      end
      
      # Function to determine all transactions for a month
      def self.monthly_transactions(key:)
        params = {created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month}
        if [:failure, :success].include?(key)
            where(params.merge(status: key))
        else
            where(params.merge(status: [:pending, :failure, :success]))
        end
      end
    
    
      def self.yearly_transactions(key:)
        params = {created_at: Time.zone.now.beginning_of_year..Time.zone.now.end_of_year}
        if [:failure, :success].include?(key)
            where(params.merge(status: key))
        else
            where(params.merge(status: [:pending, :failure, :success]))
        end
      end
    
      # Function to determine all transactions
      def self.global_transactions(key:, date:)
        query = 'created_at >= :date'
        #params = {date: DateTime.current.beginning_of_year}
         params = {date: date}
        if [:failure, :success].include?(key)
            query += ' AND status = :status'
            params.merge!(status: statuses[key])
        else
            query += ' AND status IN (0,1,2)'
        end
        where([query, params])
      end
    
      def self.today_count(key:)
         today_transactions(key: key).count
      end
    
      def self.monthly_count(key:)
         monthly_transactions(key: key).count
      end
    
      def self.yearly_count(key:)
        yearly_transactions(key: key).count
      end
    
      def self.global_count(key:, date:)
         global_transactions(key: key, date: date).count
      end
    
      def self.today_amount(key:)
        today_transactions(key: key).sum(:amount)
      end
    
      def self.monthly_amount(key:)
        monthly_transactions(key: key).sum(:amount)
      end
    
      def self.yearly_amount(key:)
        yearly_transactions(key: key).sum(:amount)
      end
    
      def self.global_amount(key:, date:)
        global_transactions(key: key, date: date).sum(:amount)
      end
    
      def self.today_tax(key:)
         today_transactions(key: key).sum(:transaction_fees)
      end
    
      def self.monthly_tax(key:)
         monthly_transactions(key: key).sum(:transaction_fees)
      end
    
      def self.yearly_tax(key:)
        yearly_transactions(key: key).sum(:transaction_fees)
      end
    
      def self.global_tax(key:, date:)
         global_transactions(key: key, date: date).sum(:transaction_fees)
      end

      def self.name_model_csv_file
        "contraventions"
      end
    
      def self.export_attributes
        ['ID', 'TICKET', 'MONTANT', 'TAX', 'TELEPHONE', 'MOYEN DE PAIEMENT', 'STATUT', 'REFERENCE DE PAIEMENT', 'DATE', 'CONTRAVENTION', 'CARNET', 'AGENT']
      end
    
      def self.export_attributes_values(record)
        [   
            record.transaction_id.to_s,
            record.ticket_number.to_s,
            record.amount,
            record.transaction_fees,
            record.msisdn.to_s,
            payment_readable(record.wallet),
            human_readable_status(record.status),
            record.payment_trnx_ref.to_s,
            record.created_at.strftime('le %d/%m/%Y à %R')
        ]
      end

      def sms_content
        if self.status == "success" 
            %(Le paiement #{self.ticket_number} de la redevance du declarant #{self.declarant_code} a été effectué avec succès!)
        else
            %(Le paiement de la redevance pour code declarant #{self.declarant_code} a échoué! Veuillez réessayer plus tard !")
        end
      end
    
      def sms_number
        self.msisdn
      end
end