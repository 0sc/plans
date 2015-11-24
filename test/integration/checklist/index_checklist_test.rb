require "test_helper"

class ChecklistIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user_with_checklist)
    @token = get_authorization_token(@user.email, "pass")
  end

  def get_user_checklist(param = nil)
    get "/v1/checklists", {q: param},{ 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body)["checklists"] unless response.body.empty?
  end

  test "returns all the users checklist" do
    assert_equal 10, @user.checklists.count
    get_user_checklist
    assert_response 200
    assert_equal 10, @payload.size
    assert_equal @user.checklists.first.name, @payload.first["name"]
  end

  test "returns empty if user does not have any checklist" do
    user = create(:user, email: "myemal@email.com")
    @token = get_authorization_token(user.email, "pass")
    assert_equal 0, user.checklists.count
    get_user_checklist
    assert_response 200
    assert_empty @payload
  end

  test "returns only checklists that match search params" do
    @user.checklists.create(name: "firstLIST")
    3.times { @user.checklists.create(name: "fakerLisT#{rand(100)}") }

    assert_equal 14, @user.checklists.count
    get_user_checklist("list")
    assert_response 200
    assert_equal 4, @payload.size
    assert_equal "firstLIST", @payload.first["name"]
  end

  test "returns empty if nothing matches search params" do
    assert_equal 10, @user.checklists.count
    get_user_checklist("andela.com")
    assert_response 200
    assert_response 200
    assert @payload.empty?
  end

  test "returns 401 if user is not logged in" do
    user_logged_out_test(:get_user_checklist)
  end

  test "returns 401 for invalid token" do
    @token = ""
    get_user_checklist
    assert_response 401
    assert_empty response.body
  end
end
