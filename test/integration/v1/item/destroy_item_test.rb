require "test_helper"

class DestroyingItemTest < ActionDispatch::IntegrationTest
  def destroy_bucketlist_item(id = @item.id, list_id = @list.id)
    delete "/v1/bucketlists/#{list_id}/items/#{id}", {}, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
  end

  setup do
    user = create(:user)
    @token = get_authorization_token(user.email, "pass")
    @list = create(:bucketlist_with_items, user: user)
    @item = @list.items.last
    assert_equal 10, @list.items.count
  end

  test "destroys bucketlist with valid params" do
    destroy_bucketlist_item
    assert_response 204
    assert_equal 9, @list.items.count
  end

  test "returns 404 if item is not found" do
    destroy_bucketlist_item(100)
    assert_response 404
    assert_empty response.body
    assert_equal 10, @list.items.count
  end

  test "returns 404 if item doesn't not belong to user" do
    user = create(:user, email: Faker::Internet.email)
    @token = get_authorization_token(user.email, "pass")

    destroy_bucketlist_item
    assert_response 404
    assert_empty response.body
    assert_equal 10, @list.items.count
  end

  test "returns 404 if bucketlist params is invalid" do
    destroy_bucketlist_item(@item.id, 1000)
    assert_response 404
    assert_empty response.body
    assert_equal 10, @list.items.count

    destroy_bucketlist_item(@item.id, "1000")
    assert_response 404
    assert_empty response.body
    assert_equal 10, @list.items.count
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:destroy_bucketlist_item)
  end

  test "returns 401 for invalid token" do
    @token = ""
    destroy_bucketlist_item
    assert_response 401
    assert_empty response.body
    assert_equal 10, @list.items.count
  end
end
