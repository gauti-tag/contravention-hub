class PushSmsJob < ApplicationJob
    queue_as :default

    def perform(transaction_id, model)
        record = model.to_s.constantize.find_by(transaction_id: transaction_id)
        response_sender_sms = Gateway::SmsGatewayNgser.push(record.sms_number, record.sms_content)
        status_sms = response_sender_sms.success? == true
        record.update(receive_sms: status_sms)
    end
end
