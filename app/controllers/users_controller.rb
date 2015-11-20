class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  def update
  end

  def login
    #authorize and create
  end

  def logout
    # invalidate token
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:email, :password)
  end
end
