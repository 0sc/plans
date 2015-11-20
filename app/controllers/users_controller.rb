class UsersController < ApplicationController
  before_action :set_user, only: show
  def create
    user = User.new(email: params[:email], name: params[:name])
    if user.save
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
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

  def set_user
    user = User.find_by(id: 1)
    render json "", status: :unprocessable_entity
  end
end
