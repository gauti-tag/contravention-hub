class AddOperationTypeToPayments < ActiveRecord::Migration[6.0]
  def change
    [:cni_payments, :civil_act_payments, :traffic_ticket_payments].each do |table|
      # Remove operation_type column and add foreign key from operation_types table
      remove_column table, :operation_type if column_exists?(table, :operation_type)
      add_reference table, :operation_type, foreign_key: true
    end
  end
end
