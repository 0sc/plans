ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "simplecov"
SimpleCov.start
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "rails/test_help"

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
  def json(body)
    JSON.parse(body, symbolize_name: true)
  end

  def get_authorization_token(email, password)
    post(
      "/auth/login",
      { user: { email: email, password: password } }.to_json,
      "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s
    )
    assert_equal Mime::JSON, response.content_type
    json(response.body)["auth_token"]
  end

  def user_logged_out_test(method)
    return unless @user
    @user.update(active: false)
    refute @user.active
    send(method)
    assert_response 401
  end
end
