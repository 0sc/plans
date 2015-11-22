require "test_helper"

class DestroyingItemTest < ActionDispatch::IntegrationTest
  def destroy_checklist_item(id = @item.id, list_id = @list.id)
    delete "/v1/checklists/#{list_id}/items/#{id}", {}, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
  end

  setup do
    user = create(:user)
    @token = get_authorization_token(user.email, "pass")
    @list = create(:checklist_with_items, user: user)
    @item = @list.items.last
    assert_equal 10, @list.items.count
  end

  test "destroys checklist with valid params" do
    destroy_checklist_item
    assert_response 204
    assert_equal 9, @list.items.count
  end

  test "returns 422 if item is not found" do
    destroy_checklist_item(100)
    assert_response 422
    assert_empty response.body
    assert_equal 10, @list.items.count
  end

  test "returns 422 if item doesn't not belong to user" do
    user = create(:user, email: Faker::Internet.email)
    @token = get_authorization_token(user.email, "pass")

    destroy_checklist_item
    assert_response 422
    assert_empty response.body
    assert_equal 10, @list.items.count
  end

  test "returns 422 if checklist params is invalid" do
    destroy_checklist_item(@item.id, 1000)
    assert_response 422
    assert_empty response.body
    assert_equal 10, @list.items.count

    destroy_checklist_item(@item.id, "1000")
    assert_response 422
    assert_empty response.body
    assert_equal 10, @list.items.count
  end

  test "returns 401 for invalid token" do
    @token = ""
    destroy_checklist_item
    assert_response 401
    assert_empty response.body
    assert_equal 10, @list.items.count
  end
end
