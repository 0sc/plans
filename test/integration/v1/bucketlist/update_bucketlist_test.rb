require "test_helper"

class UpdatingBucketlistTest < ActionDispatch::IntegrationTest
  def update_user_bucketlist(id = @list.id, name = "Modified")
    patch(
      "/v1/bucketlists/#{id}",
      { bucketlist: { name: name } }.to_json,
      "Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s,
      "Authorization" => "Token #{@token}"
    )

    assert_equal Mime::JSON, response.content_type
    unless response.body.empty?
      @payload = json(response.body)["bucketlist"]
      @payload = @payload["errors"] unless @no_errors
    end
  end

  def assertions_for_invalid_update_request(param, message)
    update_user_bucketlist(@list.id, param)
    assert_response 422
    assert @payload.include? message
    refute_equal "Modified", @list.reload.name
  end

  setup do
    user = create(:user_with_bucketlist)
    @token = get_authorization_token(user.email, "pass")
    @list = user.bucketlists.last
  end

  test "updates the details of a bucketlist with valid params" do
    @no_errors = true
    update_user_bucketlist
    assert_response 200
    refute_equal @list.name, @payload["name"]
    assert_equal "Modified", @payload["name"]
    assert_equal @list.reload.name, @payload["name"]
  end

  test "returns 404 if bucketlist id is invalid" do
    update_user_bucketlist(100)
    assert_response 404
    assert_empty response.body
    refute_equal "Modified", @list.reload.name
  end

  test "it returns 400 if strong params is invalid" do
    patch(
      "/v1/bucketlists/#{@list.id}",
      { name: "Modified" }.to_json,
      "Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s, "Authorization" => "Token #{@token}"
    )

    assert_equal Mime::JSON, response.content_type
    assert_response 400
    assert_equal @list, @list.reload
  end

  test "returns 422 if params is empty" do
    assertions_for_invalid_update_request("", "Name can't be blank")
  end

  test "returns 422 if new name is too long" do
    assertions_for_invalid_update_request(
      Faker::Lorem.characters(101),
      "Name is too long (maximum is 100 characters)"
    )
  end

  test "returns 422 if new name is too short" do
    assertions_for_invalid_update_request(
      Faker::Lorem.characters(1),
      "Name is too short (minimum is 2 characters)"
    )
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:update_user_bucketlist)
  end

  test "returns 401 for invalid token" do
    @token = ""
    update_user_bucketlist
    assert_response 401
    assert_empty response.body
    refute_equal @list.reload.name, "Modified"
  end
end
