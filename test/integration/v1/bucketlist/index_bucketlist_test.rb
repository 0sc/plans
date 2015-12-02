require "test_helper"

class BucketlistIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user_with_bucketlist)
    @token = get_authorization_token(@user.email, "pass")
  end

  def get_user_bucketlist(param = nil)
    get(
      "/v1/bucketlists",
      { q: param },
      "Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s,
      "Authorization" => "Token #{@token}"
    )
    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body)["bucketlists"] unless response.body.empty?
  end

  test "returns all the users bucketlist" do
    assert_equal 10, @user.bucketlists.count
    get_user_bucketlist
    assert_response 200
    assert_equal 10, @payload.size
    assert_equal @user.bucketlists.first.name, @payload.first["name"]
  end

  test "returns empty if user does not have any bucketlist" do
    user = create(:user, email: "myemal@email.com")
    @token = get_authorization_token(user.email, "pass")
    assert_equal 0, user.bucketlists.count
    get_user_bucketlist
    assert_response 200
    assert_empty @payload
  end

  test "returns only bucketlists that match search params" do
    @user.bucketlists.create(name: "firstLIST")
    3.times { @user.bucketlists.create(name: "fakerLisT#{rand(100)}") }

    assert_equal 14, @user.bucketlists.count
    get_user_bucketlist("list")
    assert_response 200
    assert_equal 4, @payload.size
    assert_equal "firstLIST", @payload.first["name"]
  end

  test "returns empty if nothing matches search params" do
    assert_equal 10, @user.bucketlists.count
    get_user_bucketlist("andela.com")
    assert_response 200
    assert_response 200
    assert @payload.empty?
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
