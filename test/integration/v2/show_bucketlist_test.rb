require "test_helper"

class V2ShowBucketlistTest < ActionDispatch::IntegrationTest
  def get_user_bucketlist(param = @list.id)
    get "/v2/bucketlists/#{param}", {}, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body)["bucketlist"] unless response.body.empty?
  end

  setup do
    user = create(:user_with_bucketlist)
    @token = get_authorization_token(user.email, "pass")
    @list = user.bucketlists.first
  end

  test "shows the details of a valid bucketlist" do
    get_user_bucketlist
    assert_response 200
    assert_equal @list.name, @payload["name"]
  end

  test "returns 404 if bucketlist is not found" do
    get_user_bucketlist(1000)
    assert_response 404
    assert_empty response.body
  end

  test "returns details if bucketlist does not belong to user" do
    user = create(:user, email: Faker::Internet.email)
    @token = get_authorization_token(user.email, "pass")
    get_user_bucketlist
    assert_response 200
    refute_empty response.body
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:get_user_bucketlist)
  end

  test "returns 401 for invalid token" do
    @token = ""
    get_user_bucketlist
    assert_response 401
    assert_empty response.body
  end
end
