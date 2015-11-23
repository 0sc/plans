require "test_helper"

class CreatingCheckListTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @token = get_authorization_token(@user.email, "pass")
  end

  def setup_create_checklist(name = Faker::Name.name)
    post "/v1/checklists", {
      checklist: { name: name} }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
    assert_equal Mime::JSON, response.content_type
    @root ||= "checklists"
    @payload = json(response.body)[@root] unless response.body.empty?
  end

  def assertions_for_invalid_create_action (params, message)
    assert_equal 0, @user.checklists.count
    setup_create_checklist (params)
    assert_response 422
    assert @payload.include? message
    assert_equal 0, @user.checklists.count
  end

  test "create checklist if params is valid" do
    assert_equal 0, @user.checklists.count
    @root = "checklist"
    setup_create_checklist ("My Checklist")
    assert_response 201
    assert_equal "My Checklist",  @payload["name"]
    assert_equal 1, @user.checklists.count
  end

  test "does not create checklist if params is invalid" do
    assertions_for_invalid_create_action("", "Name can't be blank")
  end

  test "does not create checklist if name is too long" do
    assertions_for_invalid_create_action(Faker::Lorem.characters(101), "Name is too long (maximum is 100 characters)")
  end

  test "does not create checklist if name is too short" do
    assertions_for_invalid_create_action(Faker::Lorem.characters(1), "Name is too short (minimum is 2 characters)")
  end

  test "returns 422 if user is not logged in" do
    user_logged_out_test(:setup_create_checklist)
  end

  test "does not create checklist if auth_token is invalid" do
    assert_equal 0, @user.checklists.count
    @token = ""
    setup_create_checklist
    assert_response 401
    assert_equal 0, @user.checklists.count
  end
end
