class UsersController < ApplicationController
  serialization_scope nil
  before_action :authenticate_token, except: [:create, :login]

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :POST, '/users', 'Create an user'
  param :user, Hash do
    param :email, :undef
    param :name, :undef
    param :password, :undef
  end
  error code: 422
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
      # render json: user.merge(token(user)), status: 201
    else
      render json: user.errors.full_messages, status: 422
    end
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :PATCH, '/users', 'Update an user'
  param :email, :undef
  param :name, :undef
  param :password, :undef
  param :user, Hash do
    param :email, :undef
    param :name, :undef
    param :password, :undef
  end
  error code: 401
  error code: 422
  def update
    data = user_params
    if data.empty?
      render json: current_user, status: 422
    else
      if current_user.update(data)
        render json: current_user, status: 200
      else
        render json: current_user.errors.full_messages, status: 422
      end
    end
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :POST, '/auth/login'
  param :user, Hash do
    param :email, :undef
    param :password, :undef
  end
  error code: 422
  def login
    user = User.find_by_email(user_params[:email])
    if user && user.authenticate(user_params[:password])
      user.update!(active: true)
      render json: token(user), status: 200
    else
      render json: "", status: 422
    end
  end

  # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENARATING NEXT TIME
  api :GET, '/auth/logout'
  error code: 401
  def logout
    current_user.update(active: false)
    render json: "", status: 200
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:email, :password, :name)
  end

  def token (user)
    { auth_token: TokenManager.new(request).generate_token(user.id) }
  end
end
