class TrafficTicketPayment < PaymentRecord
  belongs_to :contravention_notebook
  belongs_to :contravention_type
  belongs_to :agent

  validates :ticket_number, uniqueness: true, allow_blank: true

  def attributes
    {
      'transaction_id' => nil,
      'ticket_number' => nil,
      'msisdn' => nil,
      'amount' => nil,
      'currency' => nil,
      'created_at' => nil,
      'status' => nil,
      'payment_trnx_ref' => nil,
      'partner_code' => nil,
      'wallet' => nil,
      'transaction_fees' => nil,
      'operation_type_id' => nil,
      'contravention_notebook_id' => nil,
      'contravention_type_id' => nil
    }
  end

  def additional_attrs
    [
     :record_date,
     :operation_type_name,
     :operation_type_code,
     :contravention_type_name,
     :contravention_type_code,
     :contravention_notebook_name,
     :contravention_notebook_code,
     :contravention_agent_fullname,
     :contravention_agent_identifier,
     :contravention_agent_grade
    ]
  end

  def operation_type_name
    operation_type.try(:label)
  end

  def operation_type_code
    operation_type.try(:code)
  end

  def contravention_type_name
    contravention_type.try(:label)
  end

  def contravention_type_code
    contravention_type.try(:code)
  end

  def contravention_notebook_name
    contravention_notebook.try(:label)
  end

  def contravention_notebook_code
    contravention_notebook.try(:number)
  end

  def contravention_agent_fullname
    "#{agent.try(:last_name)} #{agent.try(:first_name)}"
  end

  def contravention_agent_identifier
    agent.try(:identifier)
  end

  def contravention_agent_grade
    agent.try(:grade)
  end

  def self.filter_columns
    %w[transaction_id msisdn payment_trnx_ref ticket_number]
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

  #def self.export_attributes
  #  attribute_names.reject { |name| ["id", "created_at", "update_at", "currency", "request_body", "response_data", "response_code", "contravention_type_id", "contravention_notebook_id", "agent_id", "operation_type_id"] }
  #end

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
        record.created_at.strftime('le %d/%m/%Y à %R'),
        record.contravention_type.code.to_s,
        record.contravention_notebook.number.to_s,
        record.agent.identifier.to_s
    ]
  end

  def sms_content
    if self.status == "success" 
        %(Le paiement de la contravention #{self.ticket_number} a été effectué avec succès!)
    else
        %(Le paiement de la contravention #{self.ticket_number} a échoué! Veuillez réessayer plus tard !")
    end
  end

  def sms_number
    self.msisdn
  end
end
