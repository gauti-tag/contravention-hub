# Cette classe récupère les données pour datatables
class TrafficTicketDatatable < ApplicationDatatable

  def columns
    %w(ticket_number msisdn payment_trnx_ref amount transaction_fees created_at status wallet transaction_id)
  end

  def searching_columns
    %w(ticket_number msisdn payment_trnx_ref transaction_id wallet)
  end

end
