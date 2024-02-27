module Gateway
  class InitPayment
    class << self
      def call(params:)
        service = new(params: params)
        execution = service.request
        execution.run
        response = JSON.parse(execution.response.body)
        code = response['result']['code']
        message = response['result']['data']
        OpenStruct.new(status: response['api_code'], request: response['request'], response: response['result'], code: code, wallet: response['wallet'], gateway_transaction_id: response['transaction_id'], message: message)
      end
    end

    attr_reader :params, :request

    private

    def initialize(params:)
      @params = params
      @request = Typhoeus::Request.new("#{ENV['GATEWAY_PAYMENT_ENDPOINT']}/MMGG/InitPayment",
        method: :post,
        headers: { 'Accept-Encoding' => 'application/json', 'Content-Type' => 'application/json', Authorization: auth_token },
        body: params.to_json)
    end

    def auth_token
      @auth_token ||= auth_request
    end

    def auth_request
      auth_req = Typhoeus::Request.new("#{ENV['GATEWAY_PAYMENT_ENDPOINT']}/auth", 
        method: :post,
        headers: { 'Accept-Encoding' => 'application/json', 'Content-Type'=> 'application/json'},
        body: auth_params.to_json
      )
      auth_req.run
      return if auth_req.response.code != 200

      response_body = JSON.parse(auth_req.response.body)
      response_body['auth_token']
    end

    def auth_params
      {
        auth: {
          name: service.name,
          authentication_token: service.token,
          order: params[:order_id]
        }
      }
    end

    def service 
        @service ||= Service.find_by(alias: params[:operation_type])
    end

  end
end