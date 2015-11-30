require "test_helper"

class V2::BucketlistIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user_with_bucketlist, amount: 5)
    @token = get_authorization_token(@user.email, "pass")
    create(:user_with_bucketlist, email: Faker::Internet.email)
    assert_equal 5, @user.bucketlists.count
    assert_equal 15, Bucketlist.count
  end

  def get_user_bucketlist(param = {})
    get "/v2/bucketlists", param,{ 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
    assert_equal Mime::JSON, response.content_type
    assert_response 200
    @payload = json(response.body)["bucketlists"] unless response.body.empty?
  end

  def create_entries_for_search
    assert_equal 2, User.count
    @user.bucketlists.create(name: "Stardom")
    User.last.bucketlists.create(name: "Stardust")
    @user.bucketlists.create(name: "Starprize")
  end

  test "returns all avaliable bucketlists" do
    get_user_bucketlist
    assert_equal 15, @payload.size
    assert_equal @user.bucketlists.first.name, @payload.first["name"]
    assert_equal Bucketlist.last.name, @payload.last["name"]
  end

  test "returns only current_user bucketlists" do
    get_user_bucketlist(o: "user")
    refute_equal 15, @payload.size
    assert_equal 5, @payload.size
    assert_equal @user.bucketlists.first.name, @payload.first["name"]
  end

  test "returns only bucketlists not belonging to user" do
    get_user_bucketlist(o: "not_user")
    refute_equal 15, @payload.size
    assert_equal 10, @payload.size
    assert_equal Bucketlist.find(1).name, @payload.first["name"]
  end

  test "searches all avaliable bucketlists" do
    create_entries_for_search

    get_user_bucketlist(q: "star")
    assert_equal 3, @payload.size
    assert_equal @user.bucketlists.last.name, @payload.last["name"]
  end

  test "searches only current_user's bucketlists" do
    create_entries_for_search

    get_user_bucketlist(q: "star", o: "user")
    assert_equal 2, @payload.size
    assert_equal @user.bucketlists.last.name, @payload.last["name"]
  end

  test "searches only bucketlists not belonging to current_user" do
    create_entries_for_search

    get_user_bucketlist(q: "star", o: "not_user")
    assert_equal 1, @payload.size
    refute_equal @user.bucketlists.last.name, @payload.first["name"]
    assert_equal Bucketlist.find(17).name, @payload.first["name"]
  end

  test "paginates result" do
  end
end
