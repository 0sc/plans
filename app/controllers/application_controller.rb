class ApplicationController < ActionController::API
  # include ::ActionController::Serialization

  def current_user
    @current_user || authenticate_token
  end

  def authenticate_token
    payload, header =  TokenManager.new(request).authenticate!
    @current_user = User.find_by(id: payload["user"])
    return if @current_user

    head 401
  end
end
