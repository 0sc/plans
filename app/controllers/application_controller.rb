class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ProcessingUtilities

  def current_user
    head 401 unless @current_user
    @current_user
  end

  def authenticate_token
    payload, header =  TokenManager.new(request).authenticate!
    @current_user = User.find_by(id: payload["user"])
    return if @current_user && @current_user.active

    head 401, content_type: "application/json"
  end
end
