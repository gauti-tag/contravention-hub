# Cette classe récupère les données pour datatables
class RedevanceDatatable < ApplicationDatatable

    def columns
      %w(ticket_number declarant_code msisdn payment_trnx_ref amount transaction_fees created_at status wallet transaction_id)
    end
  
    def searching_columns
      %w(ticket_number declarant_code msisdn payment_trnx_ref transaction_id wallet)
    end
  
  end
  