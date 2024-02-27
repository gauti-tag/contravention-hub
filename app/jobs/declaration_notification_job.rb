class DeclarationNotificationJob < ApplicationJob
    queue_as :declaration_ussd_notification

    def perform transaction_id
        record = Declaration.find_by(transaction_id: transaction_id)
        uri = record.wallet == 'mtn_guinee' ? ENV['URI_NOTIF_DECLARATION_MTN'] : ENV['URI_NOTIF_DECLARATION_ORANGE'] 
        notif_sent = Notification::Declaration::Ussd.push(record.notification_data, uri)
        record.update(notification_sent: true, quittance_number: notif_sent.quittance, notify_at: Time.now) if notif_sent.status?
    end
end 
