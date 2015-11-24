require "test_helper"

class UpdatingChecklistTest < ActionDispatch::IntegrationTest
  def update_user_checklist(id = @list.id, name = "Modified")
    patch "/v1/checklists/#{id}", { checklist: { name: name } }.to_json, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }

    assert_equal Mime::JSON, response.content_type
    @root ||= "checklist"
    @payload = json(response.body)[@root] unless response.body.empty?
  end

  def assertions_for_invalid_update_request(param, message)
    @root = "checklists"
    update_user_checklist(@list.id, param)
    assert_response 422
    assert @payload.include? message
    refute_equal "Modified", @list.reload.name
  end

  setup do
    user = create(:user_with_checklist)
    @token = get_authorization_token(user.email, "pass")
    @list = user.checklists.last
  end

  test "updates the details of a checklist with valid params" do
    update_user_checklist
    assert_response 200
    refute_equal @list.name, @payload["name"]
    assert_equal "Modified", @payload["name"]
    assert_equal @list.reload.name, @payload["name"]
  end

  test "returns 404 if checklist id is invalid" do
    update_user_checklist(100)
    assert_response 404
    assert_empty response.body
    refute_equal "Modified", @list.reload.name
  end

  test "it returns 422 if not strong params is invalid" do
    patch "/v1/checklists/#{@list.id}", { name: "Modified" }.to_json, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }

    assert_equal Mime::JSON, response.content_type
    assert_response 422
    assert_equal @list, @list.reload
  end

  test "returns 422 if params is empty" do
    assertions_for_invalid_update_request("", "Name can't be blank")
  end

  test "returns 422 if new name is too long" do
    assertions_for_invalid_update_request(Faker::Lorem.characters(101),
    "Name is too long (maximum is 100 characters)")
  end

  test "returns 422 if new name is too short" do
    assertions_for_invalid_update_request(Faker::Lorem.characters(1), "Name is too short (minimum is 2 characters)")
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:update_user_checklist)
  end

  test "returns 401 for invalid token" do
    @token = ""
    update_user_checklist
    assert_response 401
    assert_empty response.body
    refute_equal @list.reload.name, "Modified"
  end
end
