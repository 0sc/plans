class UsersController < ApplicationController
  serialization_scope nil
  before_action :authenticate_token, except: [:create, :login]

  resource_description do
    short "Managing User profile"
  end

  api :POST, '/users', 'Create a user'
  description <<-EOS
    == Create User
     This endpoint is used to create a new user profile.
  EOS
  formats ['json']
  param :user, Hash, description: "User account details" do
    param :email, String, desc: "Email for login", required: true
    param :name, String, required: true
    param :password, String, "password for login", required: true
  end
  error code: 422, desc: "Invalid parameter sent"
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
      # render json: user.merge(token(user)), status: 201
    else
      render json: user.errors.full_messages, status: 422
    end
  end

  api :PATCH, '/users', 'Update User information'
  description <<-EOS
    == Update User Profile
     This endpoint is used to update the user profile details.
    === Authentication required
     Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
  EOS
  formats ['json']
  param :user, Hash do
    param :email, String, desc: "Email for login"
    param :name, String
    param :password, String, "password for login"
  end
  error code: 401, desc: "Unauthorized. Token is probably invalid."
  error code: 422, desc: "Invalid parameter sent"
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

  api :POST, '/auth/login'
  description <<-EOS
    == Authenticate User
     This endpoint is used to authenticate a user account.
  EOS
  formats ["json"]
  param :user, Hash do
    param :email, String, desc: "User email", required: true
    param :password, String, desc: "User password", required: true
  end
  error code: 422, desc: "Query params could not be processed. User not yet created or invalid params provided."
  def login
    user = User.find_by_email(user_params[:email])
    if user && user.authenticate(user_params[:password])
      user.update!(active: true)
      render json: token(user), status: 200
    else
      head 422
    end
  end

  api :GET, '/auth/logout'
  description <<-EOS
    == Logout user
     This endpoint is used to terminate access to an authenticated account by invalidating the token if it has not expired.
    === Authentication required
     Authentication token has to be passed as part of the request. It must be passed as HTTP header(TOKEN).
  EOS
  formats ['json']
  error code: 401, desc: "Unauthorized. Token is probably invalid."
  error code: 422, desc: "User information could not be processed."
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
