require "jwt"
class TokenManager
  attr_reader :request

  def initialize(arg)
    @request = arg
  end

  def generate_token(user_id, exp = 24.hours.from_now)
    payload = { user: user_id, exp: exp.to_i }
    issue_token(payload)
  end

  def issue_token(payload)
    JWT.encode(payload, secret, "HS512")
  end

  def secret
    Rails.application.secrets.secret_key_base
  end

  def valid?(token)
    JWT.decode(token, secret, true, algorithm: "HS512")
  end

  def authenticate!
    valid?(token)
  rescue
    ["", 401]
  end

  def token
    request.headers["Authorization"].split(" ").last
  end
end
