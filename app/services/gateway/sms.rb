require 'typhoeus'

module Gateway
    class Sms

        SMS_URI = 'ad7e2b2a24677ed2eecf953edf1abfa1/b19e8e47-19f5-4162-8447-e56cb5ef8a34/api/message'

        def self.push(msisdn = nil , message = nil)

            url = "#{ENV['PUSHER_SMS_URL']}/#{SMS_URI}/#{ENV['SMS_LOGIN']}/#{ENV['SMS_PASSWORD']}/#{ENV['SMS_SERVICE_ID']}/#{ENV['SMS_SENDER']}/#{msisdn}/#{message}"
            safe_url = URI.encode(url.strip)

            request = Typhoeus::Request.new(
            safe_url,
            method: :get
            )

            request.run
            request.response.body
        end
    end
end