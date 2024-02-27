require 'typhoeus'
module Notification
    module Redevance
        class Ussd
            URI = '/ws_ri/ussd/payerOMVersWS'
            def self.push params
                url = "#{ENV['REDEVANCE_NOTIFICATION_URL']}#{URI}?token=#{ENV['REDEVANCE_TOKEN']}&msisdn=#{params[:msisdn]}&identifiant=#{params[:identifiant]}&id_transaction=#{params[:id_transaction]}&montant=#{params[:montant]}"
                safe_url = URI(url.strip)
    
                request = Typhoeus::Request.new(
                safe_url,
                method: :get
                )
    
                request.run
                request.response.code
            end
        end
    end
end