require 'jwt'

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
    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS512")
  end

  def valid?(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: "HS512" })
  end

  def authenticate!
    begin
      valid?(token)
    rescue
      ["", 401]
    end
  end

  def token
    request.headers['Authorization'].split(" ").last
  end
end
