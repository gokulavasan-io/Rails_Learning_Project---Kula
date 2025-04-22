require "jwt"

class JsonWebToken
  SECRET_KEY = 'a78fdc12d93274b74f9a3a2f98cf4301c1a819d822c4481e2e9b07175c33c789'

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    decoded.symbolize_keys
  rescue JWT::DecodeError
    nil
  end
end
