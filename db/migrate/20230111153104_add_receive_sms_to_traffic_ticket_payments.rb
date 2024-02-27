class AddReceiveSmsToTrafficTicketPayments < ActiveRecord::Migration[6.0]
    def change
        add_column :traffic_ticket_payments, :receive_sms, :boolean, default: :false
    end
  end
  