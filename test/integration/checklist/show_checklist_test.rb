require "test_helper"

class ShowChecklistTest < ActionDispatch::IntegrationTest
  def get_user_checklist(param = @list.id)
    get "/v1/checklists/#{param}", {}, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
    assert_equal Mime::JSON, response.content_type

    @payload = json(response.body)["checklist"] unless response.body.empty?
  end

  setup do
    user = create(:user_with_checklist)
    @token = get_authorization_token(user.email, "pass")
    @list = user.checklists.first
  end

  test "show the details of a valid checklist" do
    get_user_checklist
    assert_response 200
    assert_equal @list.name, @payload["name"]
  end

  test "returns 422 if checklist is not found" do
    get_user_checklist(1000)
    assert_response 422
    assert_empty response.body
  end

  test "returns 422 if checklist does not belong to user" do
    user = create(:user, email: Faker::Internet.email)
    @token = get_authorization_token(user.email, "pass")
    get_user_checklist
    assert_response 422
    assert_empty response.body
  end

  test "returns 422 if user is not logged in" do
    user_logged_out_test(:get_user_checklist)
  end

  test "returns 401 for invalid token" do
    @token = ""
    get_user_checklist
    assert_response 401
    assert_empty response.body
  end
end
