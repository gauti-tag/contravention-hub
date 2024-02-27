require 'typhoeus'
require 'ostruct'
module Notification
    module Declaration
        class Ussd
            def self.push params, uri
                request = Typhoeus::Request.new(
                    "#{ENV['URL_NOTIF_DECLARATION']}#{uri}",
                    method: :post,
                    body: params.to_json,
                    headers: {
                        'Content-Type' => 'application/json'
                    }
                )
                request.run
                response = JSON.parse(request.response.body)
                Rails.logger.debug("Notification Post paiement Declaration #{request.inspect}")
                status = response['status'].to_i == 200
                OpenStruct.new(status?: status, quittance: response['numero_quittance'], description: response["description"])
            end
        end
    end
end