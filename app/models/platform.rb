class Platform < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def authenticate(secret)
    Devise::Encryptor.compare self.class, self.api_secret_encrypted, secret
  end

  def api_secret_encrypted
    Devise::Encryptor.digest(self.class, api_secret)
  end

  def self.pepper
    Devise.pepper
  end

  def self.stretches
    Devise.stretches
  end

  def generate_credentials
    return if api_key.present?
    
    loop do
      @api_key = Devise.friendly_token
      break @api_key unless Platform.find_by(api_key: @api_key)
    end
    @api_secret = Devise.friendly_token
    self.update api_key: @api_key, api_secret: @api_secret
  end

end
