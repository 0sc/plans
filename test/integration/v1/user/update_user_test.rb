require "test_helper"

class UpdatingUserTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, password: "password")
    @token = get_authorization_token(@user.email, "password")
  end

  def setup_user_update(token="", name=nil, email=nil, password=nil, route = "/users")
    name ||= Faker::Name.name
    email ||= Faker::Internet.email
    password ||= Faker::Internet.password(10)

    patch route,
      { user: { name: name, email: email, password: password }
      }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s,
        "Authorization" => "Token #{token}" }

    assert_equal Mime::JSON, response.content_type
    @root ||= "users"
    @payload = json(response.body)[@root] unless response.body.empty?
  end

  def assertions_for_invalid_request
    assert_response 422
    assert_equal @user.email, @user.reload.email
    assert_equal @user.name, @user.reload.name
    assert_equal @user.password, @user.reload.password
  end

  test "returns 401 for request with invalid token" do
    setup_user_update(nil, "", @user.email, @user.password)
    assert_response 401
  end

  test "returns 422 for request with empty params" do
    setup_user_update(@token, "", "", "")
    assertions_for_invalid_request
    assert @payload.include? "Email can't be blank"
    assert @payload.include? "Name can't be blank"
  end

  test "returns 422 for request without strong params" do
    patch "/users",
      { name: "NewName", email: "new@email.com", password: "newpass" }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s,
        "Authorization" => "Token #{@token}" }

    assert_equal Mime::JSON, response.content_type
    assert_response 400
    payload = json(response.body)["user"]
    assert_equal @user.name, payload["name"]
    assert_equal @user.email, payload["email"]
  end

  test "returns 422 for request with invalid email" do
    setup_user_update(@token, nil, "4546$%$", nil)
    assertions_for_invalid_request
    refute_equal "4546$%$", @user.email
    assert @payload.include? "Email is invalid"
  end

  test "returns 422 for request with invalid name" do
    setup_user_update(@token, "", "", "")
    assertions_for_invalid_request
    assert @payload.include? "Name can't be blank"
  end

  test "returns 422 for request with invalid password" do
    # setup_user_update(@token, nil, nil, "")
    # assertions_for_invalid_request
    # assert @payload.include? "Password can't be blank"
  end

  test "returns 200 for request with valid params" do
    @root = "user"
    setup_user_update(@token, nil, "email@email.com")
    assert_response 200
    old_user = @user.dup
    refute_equal old_user.email, @user.reload.email
    refute_equal old_user.name, @user.name
    refute_equal old_user.password_digest, @user.password_digest
    assert_equal "email@email.com", @payload["email"]
  end
end
