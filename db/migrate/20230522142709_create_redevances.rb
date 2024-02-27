class CreateRedevances < ActiveRecord::Migration[6.0]
    def change
      create_table :redevances do |t|
        t.string :transaction_id, null: false, limit: 100
        t.string :ticket_number, null: false, limit: 120
        t.string :payment_trnx_ref
        t.string :partner_code, limit: 50
        t.string :msisdn, null: false, limit: 25
        t.float :amount, null: false, default: 0.0
        t.float :transaction_fees, null: false, default: 0.0
        t.string :currency, limit: 10, default: 'GNF'
        t.string :description
        t.text :request_body
        t.text :response_data
        t.integer :status, default: 0
        t.string :response_code, limit: 100
        t.integer :operation_type_id
        t.string :wallet, limit: 25
        t.string :gateway_transaction_id
        t.string :declarant_code
        t.boolean :receive_sms, default: :false
        t.boolean :notification_sent, default: :false
  
        t.timestamps
      end

        add_index :redevances, :transaction_id, unique: true
        add_index :redevances, :ticket_number, unique: true
        add_index :redevances, :payment_trnx_ref, unique: true
    end
end
