require 'test_helper'

class UserAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user_one = users(:one)
  end

  test "unauthenticated users are redirected to login" do
    get root_url
    assert_redirected_to new_user_session_url
  end

  test "authenticated users can access root url" do
    user = @user_one
    sign_in user
    get root_url
    assert_response :success, "Authenticated user should access root url"
  end
end
