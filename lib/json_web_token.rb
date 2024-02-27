# Implémente les différentes fonctionnalités liées au JWT
class JsonWebToken
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, secret, 'HS256')
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    body = JWT.decode(token, secret, 'HS256', leeway: 60 * 10)[0]
    HashWithIndifferentAccess.new body
  # raise custom error to be handled by custom handler
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    raise ExceptionHandler::ExpiredSignature, e.message
  rescue JWT::DecodeError, JWT::VerificationError => e
    raise ExceptionHandler::DecodeError, e.message
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      return false
    else
      return true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 1.hour.from_now.to_i,
      iss: "b603c0464c9bdd787192", #Rails.application.credentials.jwt[:iss],
      iat: Time.now.to_i,
      aud: "bf7d0cdd42fa0df62eac" #Rails.application.credentials.jwt[:aud]
    }
  end

  # private

  def self.secret
    "a4eee77a-2685-4c84-a4c1-497548257b18" #Rails.application.credentials.secret_key_base
  end

end