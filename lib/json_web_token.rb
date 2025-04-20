require "jwt"

class JsonWebToken
  SECRET_KEY = if Rails.env.production?
    ENV["PRO_SECRET_KEY"]
  elsif Rails.env.development?
    ENV["DEV_SECRET_KEY"]
  else
    ENV["TEST_SECRET_KEY"]
  end



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
