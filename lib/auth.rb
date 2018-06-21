class Auth
  require 'jwt'

  ALGORITHM = "HS256"

  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, ALGORITHM)
  end

  def self.decode(token)
    return nil unless token.present?
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: ALGORITHM }).first
  rescue
    nil
  end
end
