require "test_helper"

class ShowingItemTest < ActionDispatch::IntegrationTest
  def show_checklist_item(list_id = @list.id, id = @item.id)
    get "/v1/checklists/#{list_id}/items/#{id}", {}, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body)["item"] unless response.body.empty?
  end

  setup do
    user = create(:user)
    @token = get_authorization_token(user.email, "pass")
    @list = create(:checklist_with_items, user: user)
    @item = @list.items.last
  end

  test "shows the details of a checklist item with valid params" do
    show_checklist_item
    assert_response 200
    assert_equal @item.name, @payload["name"]
  end

  test "returns 404 if checklist is not found" do
    show_checklist_item(1000)
    assert_response 404
    assert_empty response.body
  end

  test "returns 404 if checklist does not belong to user" do
    user = create(:user, email: Faker::Internet.email)
    @token = get_authorization_token(user.email, "pass")
    show_checklist_item
    assert_response 404
    assert_empty response.body
  end

  test "returns 404 if item is not found" do
    show_checklist_item(@list.id, 1000)
    assert_response 404
    assert_empty response.body
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:show_checklist_item)
  end

  test "returns 401 if token is invalid" do
    @token = ""
    show_checklist_item
    assert_response 401
    assert_empty response.body
  end
end
