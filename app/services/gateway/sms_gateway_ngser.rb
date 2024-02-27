require 'typhoeus'
module Gateway
    class SmsGatewayNgser 
        URI_TOKEN = '/users/v1/login'
        URI_PUSH_SMS = '/users/v1/user/send_message/unique_message'


        def self.push(msisdn = nil , message = nil)
            sms = { number: "+#{msisdn}", message: message }
            request = Typhoeus::Request.new(
                "#{ENV['URL_SMS_GATEWAY']}#{URI_PUSH_SMS}",
                method: :post,
                headers: {
                    'Authorization' => "Bearer #{token}",
                    'Content-Type' => 'application/json'
                },
                body: sms.to_json 
                )
            request.run
            response = JSON.parse(request.response.body)
            status = response['statusCode'].to_i == 201
            OpenStruct.new(success?: status, message: response['message'])
        rescue StandardError => e
            OpenStruct.new(success?: false, message: e.inspect.to_s)
        end

        private

        def self.token
            request = Typhoeus::Request.new(
                "#{ENV['URL_SMS_GATEWAY']}#{URI_TOKEN}",
                method: :post,
                headers: {
                    'Content-Type' => 'application/json'
                },
                body: credentials.to_json 
                )
            request.run
            response = JSON.parse(request.response.body)
            response['access']

        rescue StandardError => e
            OpenStruct.new(success?: false, message: e.inspect.to_s)
        end

        def self.credentials
           {
                email: ENV['SMS_EMAIL'],
                password: ENV['SMS_PASSWORD']
           }
        end
    end
end