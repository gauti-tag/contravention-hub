class AddTransactionFeesToPayments < ActiveRecord::Migration[6.0]
  def change
    [:cni_payments, :civil_act_payments].each do |table|
      add_column table, :wallet, :string, limit: 25
      add_column table, :transaction_fees, :float, null: false, default: 0.0
    end
  end
end
