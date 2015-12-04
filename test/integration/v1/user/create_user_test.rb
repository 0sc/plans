require "test_helper"

class CreatingUsersTest < ActionDispatch::IntegrationTest
  def setup_user_post(name = nil, email = nil, password = nil, route = "/users")
    name ||= "Oscar"
    email ||= Faker::Internet.email
    password ||= Faker::Internet.password(10)

    post(
      route,
      {
        user: {
          name: name,
          email: email,
          password: password
        }
      }.to_json,
      "Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s
    )

    assert_equal Mime::JSON, response.content_type

    unless response.body.empty?
      @payload = json(response.body)["user"]
      @payload = @payload["errors"] unless @no_errors
    end
  end

  test "creates user with valid params" do
    @no_errors = true
    setup_user_post
    assert_response 201
    assert_equal "Oscar", @payload["name"]
  end

  test "does not create user with invalid email" do
    setup_user_post(nil, "454@#(*)", nil)
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Email is invalid"
  end

  test "does not create user with empty params" do
    setup_user_post("", "", "")
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Email can't be blank"
    assert @payload.include? "Name can't be blank"
    assert @payload.include? "Password can't be blank"
  end

  test "does not allow duplicate email" do
    create(:user, email: "email@email.com")
    setup_user_post("", "email@email.com", "")
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Email has already been taken"
  end

  test "does not create user with empty name" do
    setup_user_post("")
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Name can't be blank"
  end

  test "does not create user with long name" do
    setup_user_post(Faker::Lorem.characters(51))
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Name is too long (maximum is 50 characters)"
  end

  test "does not create user with short name" do
    setup_user_post(Faker::Lorem.characters(1))
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Name is too short (minimum is 2 characters)"
  end

  test "does not create user with empty password" do
    setup_user_post(nil, nil, "")
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Password can't be blank"
  end

  test "does not create user with empty email" do
    setup_user_post(nil, "", nil)
    assert_response 422
    refute @payload.include? "Oscar"
    assert @payload.include? "Email can't be blank"
  end
end
