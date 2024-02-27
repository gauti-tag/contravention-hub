class AddSheetNumberToTrafficTicketPayments < ActiveRecord::Migration[6.0]
    def change
        add_column :traffic_ticket_payments, :sheet_number, :string, default: "00"
    end
end
  