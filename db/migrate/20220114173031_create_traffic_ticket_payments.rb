class CreateTrafficTicketPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :traffic_ticket_payments do |t|
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
      t.integer :operation_type
      t.string :wallet, limit: 25
      t.references :contravention_type, null: false, foreign_key: true
      t.references :contravention_notebook, null: false, foreign_key: true
      t.references :agent, null: false, foreign_key: true

      t.timestamps
    end

    add_index :traffic_ticket_payments, :transaction_id, unique: true
    add_index :traffic_ticket_payments, :ticket_number, unique: true
    add_index :traffic_ticket_payments, :payment_trnx_ref, unique: true
  end
end
