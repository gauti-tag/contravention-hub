class CreateCniPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :cni_payments do |t|
      t.string :transaction_id, null: false, limit: 100
      t.string :payment_trnx_ref
      t.string :partner_code, limit: 50
      t.string :msisdn, null: false, limit: 25
      t.float :amount, null: false, default: 0.0
      t.string :currency, limit: 10, default: 'GNF'
      t.string :description
      t.text :request_body
      t.text :response_data
      t.integer :status, default: 0
      t.string :response_code, limit: 100
      t.integer :operation_type

      t.timestamps
    end

    add_index :cni_payments, :transaction_id, unique: true
    add_index :cni_payments, :payment_trnx_ref, unique: true
  end
end
