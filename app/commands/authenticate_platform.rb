class AuthenticatePlatform
  class << self
    def call(api_key:, api_secret:)
      service = new(api_key: api_key, api_secret: api_secret)
      raise ExceptionHandler::InvalidPlatform, 'Invalid credentials' unless service.platform.present?

      payload = { sub: api_key }.to_hash
      token = JsonWebToken.encode payload
      OpenStruct.new(status: 200, message: 'Authentication successful!', token: token)
    end
  end

  attr_reader :api_key, :api_secret

  def platform
    platform = Platform.find_by(api_key: api_key)
    return platform if platform && platform.authenticate(api_secret)
    
    nil
  end

  private

  def initialize(api_key:, api_secret:)
    @api_key = api_key
    @api_secret = api_secret
  end

end