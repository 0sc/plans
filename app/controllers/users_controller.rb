class UsersController < ApplicationController
  before_action :authenticate_token, except: [:create, :login]
  def create
    user = User.new(user_params)
    if user.save
      render json: user.merge(token(user)), status: 201
    else
      render json: user.errors, status: 422
    end
  end

  def update
    data = user_params
    if data.empty?
      render json: current_user, status: 422
    else
      if current_user.update(data)
        render json: current_user, status: 200
      else
        render json: current_user.errors, status: 422
      end
    end
  end

  def login
    user = User.find_by_email(user_params[:email])
    if user && user.authenticate(user_params[:password])
      render json: token(user), status: 200
    else
      head 422
    end
  end

  def logout
    # invalidate token
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:email, :password)
  end

  def token (user)
    { auth_token: TokenManager.new(request).generate_token(user.id) }
  end
end
