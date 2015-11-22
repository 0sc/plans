require "test_helper"

class DestroyingChecklistTest < ActionDispatch::IntegrationTest
  def destroy_user_checklist(id = @list.id)
    delete "/v1/checklists/#{id}", {}, { 'Accept' => Mime::JSON,
      'Content-Type' => Mime::JSON.to_s, "Authorization" => "Token #{@token}" }
  end

  setup do
    @user = create(:user_with_checklist)
    @token = get_authorization_token(@user.email, "pass")
    @list = @user.checklists.last

    assert_equal 10, @user.checklists.count
  end

  test "destroys checklist with valid params" do
    destroy_user_checklist(@list.id)
    assert_response 204
    assert_equal 9, @user.checklists.count
  end

  test "returns 422 if checklist is not found" do
    destroy_user_checklist(100)
    assert_response 422
    assert_empty response.body
    assert_equal 10, @user.checklists.count
  end

  test "returns 401 for invalid token" do
    @token = ""
    destroy_user_checklist
    assert_response 401
    assert_empty response.body
    assert_equal 10, @user.checklists.count
  end
end
