require "test_helper"

class DestroyingBucketlistTest < ActionDispatch::IntegrationTest
  def destroy_user_bucketlist(id = @list.id)
    delete(
      "/v1/bucketlists/#{id}",
      {},
      "Accept" => Mime::JSON,
      "Content-Type" => Mime::JSON.to_s,
      "Authorization" => "Token #{@token}"
    )
  end

  setup do
    @user = create(:user_with_bucketlist)
    @token = get_authorization_token(@user.email, "pass")
    @list = @user.bucketlists.last

    assert_equal 10, @user.bucketlists.count
  end

  test "destroys bucketlist with valid params" do
    destroy_user_bucketlist(@list.id)
    assert_response 204
    assert_equal 9, @user.bucketlists.count
  end

  test "returns 404 if bucketlist is not found" do
    destroy_user_bucketlist(100)
    assert_response 404
    assert_empty response.body
    assert_equal 10, @user.bucketlists.count
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:destroy_user_bucketlist)
  end

  test "returns 401 for invalid token" do
    @token = ""
    destroy_user_bucketlist
    assert_response 401
    assert_empty response.body
    assert_equal 10, @user.bucketlists.count
  end
end
