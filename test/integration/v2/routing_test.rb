require "test_helper"

class RoutingTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @token = get_authorization_token(@user.email, "pass")
  end

  def get_version_using_header(v)
    get(
      "/bucketlists",
      {},
      "Accept" => "application/vnd.plans; version=#{v}",
      "Content-Type" => Mime::JSON.to_s,
      "Authorization" => "Token #{@token}"
    )
    assert_equal Mime::JSON, response.content_type
    @payload = json(response.body)
  end

  test "should get v1 with header specification" do
    get_version_using_header(1)
    assert_response 200
  end

  test "should get v2 with header specification" do
    get_version_using_header(2)
    assert_response 200
  end

  test "should get v1 with path specification" do
    id = Faker::Number.number(1)
    assert_recognizes(
      { controller: "v1/bucketlists", action: "index" },
      path: "v1/bucketlists", method: :get
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "show", id: id },
      path: "v1/bucketlists/#{id}", method: :get
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "create" },
      path: "v1/bucketlists", method: :post
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "destroy", id: id },
      path: "v1/bucketlists/#{id}", method: :delete
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "update", id: id },
      path: "v1/bucketlists/#{id}", method: :patch
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "update", id: id },
      path: "v1/bucketlists/#{id}", method: :put
    )
  end

  test "should get v2 with path specification for index and show actions" do
    id = Faker::Number.number(1)
    assert_recognizes(
      { controller: "v2/bucketlists", action: "index" },
      path: "v2/bucketlists", method: :get
    )
    assert_recognizes(
      { controller: "v2/bucketlists", action: "show", id: id },
      path: "v2/bucketlists/#{id}", method: :get
    )
  end

  test "defaults to v1 for v2 requests to update, create, destroy actions" do
    id = Faker::Number.number(1)
    assert_recognizes(
      { controller: "v1/bucketlists", action: "create" },
      path: "v2/bucketlists", method: :post
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "destroy", id: id },
      path: "v2/bucketlists/#{id}", method: :delete
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "update", id: id },
      path: "v2/bucketlists/#{id}", method: :patch
    )
    assert_recognizes(
      { controller: "v1/bucketlists", action: "update", id: id },
      path: "v2/bucketlists/#{id}", method: :put
    )
  end
end
