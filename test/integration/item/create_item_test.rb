require "test_helper"

class CreatingItemTest < ActionDispatch::IntegrationTest
  def create_checklist_item(name = "Checklist Item", list_id = @list.id)
    post "/v1/checklists/#{list_id}/items/", {
      item: { name: name} }.to_json,
      { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }

    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body) unless response.body.empty?
  end

  def assertions_for_invalid_create_action(params, message)
    create_checklist_item(params)
    assert_response 422
    assert @payload.include? message
    assert_equal 0, @list.items.count
  end

  def assertions_with_no_message
    create_checklist_item
    assert_response 422
    assert_empty response.body
    assert_equal 0, @list.items.count
  end

  setup do
    user = create(:user)
    @token = get_authorization_token(user.email, "pass")
    @list = create(:checklist, user: user)
    assert_equal 0, @list.items.count
  end

  test "creates new item with valid params" do
    create_checklist_item
    assert_response 201
    assert_equal "Checklist Item", @payload["name"]
    assert_equal 1, @list.items.count
  end

  test "returns 422 if checklist params is invalid" do
    @list.id = 1000
    assertions_with_no_message

    @list.id = 00
    assertions_with_no_message
  end

  test "returns 422 if checklist does not belong to user" do
    user = create(:user, email: Faker::Internet.email)
    @token = get_authorization_token(user.email, "pass")
    assertions_with_no_message
  end

  test "returns 422 if params is empty" do
    assertions_for_invalid_create_action("", "Name can't be blank")
  end

  test "returns 422 if name is too long" do
    assertions_for_invalid_create_action(Faker::Lorem.characters(101), "Name is too long (maximum is 100 characters)")
  end

  test "returns 422 if name is too short" do
    assertions_for_invalid_create_action(Faker::Lorem.characters(1), "Name is too short (minimum is 2 characters)")
  end

  test "returns 422 if user is not logged in" do
    user_logged_out_test(:create_checklist_item)
  end

  test "returns 401 if token is invalid" do
    @token = ""
    create_checklist_item
    assert_response 401
    assert_empty response.body
  end
end
