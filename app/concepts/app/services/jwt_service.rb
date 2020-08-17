require 'date'

class JwtService
  DecodingError = Class.new(StandardError)

  # Generate a JWT from arguments
  def self.generate(encoding_key, encoding_value, payload)
    expiration_time = Rails.application.secrets.jwt_expiration_time.hours.from_now.to_i
    payload['exp']  = expiration_time
    jwt = JWT.encode(payload,
      Rails.application.secrets.secret_key_base, 'HS512',
      { exp: expiration_time, encoding_key.to_sym => encoding_value }
    )
    return jwt
  end

  # Validate tokens expiration date
  def self.expired?(token)
    decoded_token = JwtService.decode(token)
    expiry_timestamp = decoded_token.first['exp']
    expiration_date = Time.at(expiry_timestamp).to_datetime
    return DateTime.now > expiration_date
  rescue => err
    return true
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS512'})
  rescue => err
    raise DecodingError.new
  end
end
