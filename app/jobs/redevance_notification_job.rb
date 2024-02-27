class RedevanceNotificationJob < ApplicationJob
    queue_as :redevance_ussd_notification

    def perform transaction_id
        record = Redevance.find_by(transaction_id: transaction_id)
        notif_sent = Notification::Redevance::Ussd.push record.notification_data
        record.update(notification_sent: true) if notif_sent.to_i == 200
    end
end 
