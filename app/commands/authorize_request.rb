class AuthorizeRequest
  class << self
    def call(token:)
      raise ExceptionHandler::DecodeError, 'Missing token' if token.blank?

      service = new(token: token)
      service.decode_token
      raise ExceptionHandler::InvalidPlatform, 'Invalid token supplied.' unless service.platform

      OpenStruct.new(success?: true, status: 200, platform: service.platform)
    end
  end

  attr_reader :platform, :token

  def decode_token
    payload = JsonWebToken.decode(token)
    @platform = Platform.find_by(api_key: payload[:sub])
  end

  private

  def initialize(token:)
    @token = token
    @platform = nil
  end
end