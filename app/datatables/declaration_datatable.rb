# Cette classe récupère les données pour datatables
class DeclarationDatatable < ApplicationDatatable

    def columns
      %w(declarant_code ticket_number msisdn payment_trnx_ref amount created_at status wallet transaction_id)
    end
  
    def searching_columns
      %w(ticket_number declarant_code nif_code liquidation_number msisdn payment_trnx_ref transaction_id wallet)
    end
  
  end
  