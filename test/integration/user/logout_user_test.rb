require "test_helper"

class LogoutUserTest < ActionDispatch::IntegrationTest
  def setup_user_logout
    get "/auth/logout", { },
    { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s,
      "Authorization" => "Token #{@token}"}
  end

  setup do
    user = create(:user, password: "password")
    @token = get_authorization_token(user.email, "password")
    @user= user.reload
  end

  test "logs out user" do
    assert @user.active
    setup_user_logout

    assert_response 200
    refute @user.reload.active

    setup_user_logout
    assert_response 401
  end

  test "returns 422 if user is not logged in" do
    user_logged_out_test(:setup_user_logout)
  end

  test "returns 401 if token is invalid" do
    @token = ""
    setup_user_logout
    assert_response 401
    assert @user.active
  end
end
