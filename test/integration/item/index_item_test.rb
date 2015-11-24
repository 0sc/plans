require "test_helper"

class ItemIndexTest < ActionDispatch::IntegrationTest
  def get_checklist_items(list_id = @list.id, param = nil)
    get "/v1/checklists/#{list_id}/items", {status: param},{ 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body)["items"] unless response.body.empty?
  end

  setup do
    @user = create(:user)
    @token = get_authorization_token(@user.email, "pass")
    @list = create(:checklist_with_items, user: @user)
    @item = @list.items.last
    assert_equal 10, @list.items.count
  end

  test "returns 422 if checklist doesn't belong to user" do
    user = create(:user, email: Faker::Internet.email)
    @token = get_authorization_token(user.email, "pass")
    get_checklist_items
    assert_response 422
    assert_empty response.body
    assert_equal 10, @list.items.count
  end

  test "lists all items in given valid checklist" do
    get_checklist_items
    assert_response 200
    assert_equal 10, @payload.size
    assert_equal @item.name, @payload.first["name"]
  end

  test "lists only items that are marked completed" do
    done = @list.items.create(name: Faker::Name.name, done: true)
    3.times { |n| @list.items.create(name: Faker::Name.name + n.to_s, done: true) }

    get_checklist_items(@list.id, "done")
    assert_response 200
    assert_equal 14, @list.items.count
    assert_equal 4, @payload.size
    assert_equal done.name, @payload.first["name"]
  end

  test "lists only items that are marked as pending" do
    pending = @list.items.create(name: Faker::Name.name)
    3.times { |n| @list.items.create(name: Faker::Name.name + n.to_s, done: true) }

    get_checklist_items(@list.id, "pending")
    assert_response 200
    assert_equal 14, @list.items.count
    assert_equal 11, @payload.size
    assert_equal pending.name, @payload.last["name"]
  end

  test "returns 422 query params is not understood" do
    get_checklist_items(@list.id, "whatever")
    assert_response 422
    assert_empty response.body
  end

  test "returns empty result if checklist doesn't have items" do
    @list = create(:checklist, user: @user)
    get_checklist_items
    assert_response 200
    assert_empty @payload
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:get_checklist_items)
  end

  test "returns 401 if token is invalid" do
    @token = ""
    get_checklist_items
    assert_response 401
    assert_empty response.body
  end
end
