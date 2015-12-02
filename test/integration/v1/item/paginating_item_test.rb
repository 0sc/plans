require "test_helper"

class PaginatingItemIndexTest < ActionDispatch::IntegrationTest
  def get_bucketlist_items
    get(
      "/v1/bucketlists/#{@list.id}/items",
      { page: @page, limit: @limit },
      "Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s,
      "Authorization" => "Token #{@token}"
    )
    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body)["items"] unless response.body.empty?
  end

  def calc_first_item_id
    @first_item.id + ((@page - 1) * @limit)
  end

  def common_assertions(exp_size = @limit, allow = false)
    get_bucketlist_items
    assert_response 200
    assert_equal exp_size, @payload.size

    assert_equal @first_item.id, @payload.first["id"] if allow
  end

  def special_assertions
    exp_id = calc_first_item_id
    assert_equal exp_id, @payload.first["id"]
    assert_equal exp_id + @limit - 1, @payload.last["id"]
  end

  setup do
    user = create(:user)
    @token = get_authorization_token(user.email, "pass")
    @list = create(:bucketlist_with_items, user: user, amount: 200)
    @first_item = @list.items.first
    @last_item = @list.items.last
    assert_equal 200, @list.items.count
  end

  test "returns only 20 items if no limit is specified" do
    common_assertions(20, true)
  end

  test "returns a max of 100 items per page" do
    @limit = 200
    common_assertions(100, true)
  end

  test "returns items in the give page and within the given limit" do
    @page = 5
    @limit = 8
    common_assertions
    special_assertions

    @page = 50
    @limit = 1
    common_assertions
    special_assertions

    @page = 2
    @limit = 100
    common_assertions
    special_assertions
    assert_equal @last_item.id, @payload.last["id"]
  end

  test "returns 100 if the limit params is invalid" do
    @limit = "invalid"
    common_assertions(100, true)
    refute_equal @first_item.id + 100, @payload.last["id"]
  end

  test "returns page 1 if the page params is invalid" do
    @page = "invalid"
    @limit = 50
    common_assertions(@limit, true)
    refute_equal @last_item.id, @payload.last["id"]
  end

  test "lists only 20 items if no limit specified" do
    common_assertions(20, true)
    refute_equal @last_item.id, @payload.last["id"]
  end

  test "returns empty result if page doesn't have items" do
    @page = 1000
    refute_equal 0, @list.items.count
    get_bucketlist_items
    assert_response 200
    assert_empty @payload
  end
end
