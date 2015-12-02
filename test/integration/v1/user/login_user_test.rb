require "test_helper"

class LoginUserTest < ActionDispatch::IntegrationTest
  def setup_user_login(email = nil, password = nil)
    email ||= Faker::Internet.email
    password ||= Faker::Internet.password(10)

    post(
      "/auth/login",
      {
        user: {
          email: email,
          password: password
        }
      }.to_json,
      "Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s
    )

    # assert_equal Mime::JSON, response.content_type
  end

  def assertions_for_invalid_login
    assert_response 422
    assert_empty response.body
  end

  setup { @user = create(:user) }

  test "logs user in with valid params and returns auth_token" do
    setup_user_login(@user.email, "pass")
    assert_response 200
    payload = json(response.body)
    assert payload["auth_token"]
    assert @user.reload.active
  end

  test "return 422 with invalid params" do
    setup_user_login("", "")
    assertions_for_invalid_login
  end

  test "returns 422 if email is not found" do
    setup_user_login(Faker::Internet.email, "pass")
    assertions_for_invalid_login
  end

  test "returns 422 if email and password does not match" do
    setup_user_login(@user.email, "wrong_password")
    assertions_for_invalid_login
  end
end
