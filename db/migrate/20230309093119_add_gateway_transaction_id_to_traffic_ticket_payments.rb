class AddGatewayTransactionIdToTrafficTicketPayments < ActiveRecord::Migration[6.0]
    def change
      add_column :traffic_ticket_payments, :gateway_transaction_id, :string
    end
end
  