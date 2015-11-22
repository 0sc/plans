require "test_helper"

class UpdatingItemTest < ActionDispatch::IntegrationTest
  def update_checklist_item(list_id = @list.id, id = @item.id)
    patch "/v1/checklists/#{list_id}/items/#{id}", { item: { name: @item.name, done: @item.done } }.to_json, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }

    assert_equal Mime::JSON, response.content_type
    @root ||= "item"
    @payload = json(response.body)[@root] unless response.body.empty?
  end

  def assertions_with_no_message(id = nil)
    update_checklist_item
    assert_response 422
    assert_empty response.body
    @item.id = id if id
    assert_equal @item, @item.reload
  end

  def assertions_for_invalid_update_request(message)
    @root = "items"
    update_checklist_item
    assert_response 422
    assert @payload.include? message
    refute_equal "New name", @list.reload.name
  end

  setup do
    user = create(:user)
    @token = get_authorization_token(user.email, "pass")
    @list = create(:checklist_with_items, user: user)
    @item = @list.items.last
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

  test "updates the name of item with valid params" do
    @item.name = "New name"
    update_checklist_item
    assert_response 200
    assert_equal "New name", @payload["name"]
    assert_equal @item.reload.name, @payload["name"]
  end

  test "updates the completed status of item with valid params" do
    @item.done = true
    update_checklist_item
    assert_response 200
    assert @payload["done"]
    assert_equal @item.reload.done, @payload["done"]
  end

  test "it returns 422 if item id is invalid" do
    id = @item.id
    @item.id = 1000
    assertions_with_no_message(id)
  end

  test "it returns 422 if not strong params is invalid" do
    patch "/v1/checklists/#{@list.id}/items/#{@item.id}", {
      name: @item.name, done: @item.done }.to_json,
      { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }

    assert_equal Mime::JSON, response.content_type
    assert_response 422
    assert_equal @item, @item.reload
  end

  test "it returns 422 if params is empty" do
    @item.name = ""
    assertions_for_invalid_update_request("Name can't be blank")
  end

  test "it returns 422 if name is too long" do
    @item.name = Faker::Lorem.characters(101)
    assertions_for_invalid_update_request("Name is too long (maximum is 100 characters)")
  end

  test "it returns 422 if name is too short" do
    @item.name = Faker::Lorem.characters(1)
    assertions_for_invalid_update_request("Name is too short (minimum is 2 characters)")
  end

  test "returns 422 if user is not logged in" do
    user_logged_out_test(:update_checklist_item)
  end

  test "returns 401 for invalid token" do
    @token = ""
    update_checklist_item
    assert_response 401
    assert_empty response.body
    assert @item.name, @item.reload.name
  end
end
