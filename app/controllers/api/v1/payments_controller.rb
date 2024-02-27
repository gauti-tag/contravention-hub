module Api::V1
  class PaymentsController < ApplicationController
    skip_before_action :authenticate_request, only: :payment_ipn
    
    def init_payment
      processor = payment_service(params[:request][:transaction_type]).constantize
      result = processor.call(params: set_params)
      json_response(result.to_h, result.status)
    end

    def payment_ipn
      transaction_model = payment_model(ipn_params[:transaction_type])
      if transaction_model.present?
        transaction = transaction_model.constantize.find_by(transaction_id: ipn_params[:order_id])
        status = filter_status #ipn_params[:transaction_status].eql?('success') ? 1 : 2
        attrs = { status: status, payment_trnx_ref: ipn_params[:payment_reference] }
        if status == 1
          # To Do: Récupération du code MMGG, à implémenter
          mmgg_code = SecureRandom.hex(8)
          attrs[:partner_code] = mmgg_code
        end
        transaction.update(attrs)
        RedevanceNotificationJob.perform_later(transaction.transaction_id) if ipn_params[:transaction_type] == 'redevance_ticket' and ipn_params[:transaction_status].eql?('success')
        DeclarationNotificationJob.perform_later(transaction.transaction_id) if ipn_params[:transaction_type] == 'declaration_ticket' and ipn_params[:transaction_status].eql?('success')
        sleep 30
        transaction.reload
        PushSmsJob.perform_later(transaction.transaction_id, transaction_model) if transaction.receive_sms == false && (ipn_params[:transaction_type] == 'redevance_ticket' || (ipn_params[:transaction_type] == 'declaration_ticket' && !transaction.quittance_number.nil?))

        json_response({ status: 'Success!', code: mmgg_code })
      else
        json_response({ status: 'Fail!', code: 'NULL' }, 400)
      end
    end

    private

    def set_params
        case params[:request][:transaction_type]
        when 'traffic_ticket'
            payment_params
        when 'redevance_ticket'
            payment_redevance_params
        when 'declaration_ticket'
            payment_declaration_params
        end
    end

    def payment_params
      params.require(:request).permit(:msisdn, :amount, :currency, :wallet, :transaction_type, payload: [:description, :operation_type, :transaction_fees, :contravention_type, :contravention_notebook, :agent, :ticket_number, :sheet_number])
    end

    def payment_redevance_params
        params.require(:request).permit(:msisdn, :amount, :currency, :wallet, :transaction_type, payload: [:description, :operation_type, :transaction_fees, :ticket_number, :declarant_code])
    end

    def payment_declaration_params
        params.require(:request).permit(:msisdn, :amount, :currency, :wallet, :transaction_type, payload: [:description, :operation_type, :transaction_fees, :ticket_number, :declarant_code, :nif_code, :liquidation_number])
    end

    def ipn_params
      params.permit(:order_id, :amount, :transaction_status, :payment_reference, :transaction_type, :msisdn)
    end

    def payment_model(type)
      {
        'cni' => 'CniPayment',
        'civil_act' => 'CivilActPayment',
        'traffic_ticket' => 'TrafficTicketPayment',
        'redevance_ticket' => 'Redevance',
        'declaration_ticket' => 'Declaration'
      }.fetch(type) { "" }
    end

    def payment_service(type)
      case type
      when 'traffic_ticket'
        'TrafficPaymentProcessor'
      else
        'PaymentProcessor'
      end
    end

    def filter_status
        status = 0
        if ipn_params[:msisdn] === ENV.fetch('ORANGE_GUINEE_ROBOT_MSISDN', '224624253426')
            status = ipn_params[:transaction_status].eql?('success') ? 3 : 4
        else
            status = ipn_params[:transaction_status].eql?('success') ? 1 : 2
        end
        status
    end

  end
end