class UsersController < ApplicationController
  serialization_scope nil
  before_action :authenticate_token, except: [:create, :login]

  def create
    process_create_query(User.new(user_params))
  end

  def update
    process_update_query(current_user, user_params)
  end

  def login
    user = User.find_by_email(user_params[:email])
    if user && user.authenticate(user_params[:password])
      user.update!(active: true)
      render json: token(user), status: 200
    else
      head 422
    end
  end

  def logout
    current_user.update(active: false)
    head 200
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:email, :password, :name)
  end

  def token (user)
    { auth_token: TokenManager.new(request).generate_token(user.id) }
  end
end
