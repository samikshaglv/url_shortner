# Helper module to handle JWT encoding and decoding
class JsonWebToken
  # Secret key to encode and decode tokens
  SECRET_KEY = Rails.application.secret_key_base || 'my$ecretK3y'

  # Encode a payload with expiration time
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i # Add expiration time to the payload
    JWT.encode(payload, SECRET_KEY) # Encode the payload using the secret key
  end

  # Decode a JWT token and return the payload
  def self.decode(token)
    # Decode the token and return the payload
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body) # Convert payload to a hash with indifferent access
  rescue JWT::ExpiredSignature
    nil # Token has expired
  rescue JWT::DecodeError
    nil # Token is invalid
  end
end
