require 'test_helper'

class PublicsControllerTest < ActionController::TestCase
  test "should get user_agreement" do
    get :user_agreement
    assert_response :success
  end

  test "should get privacy_policy" do
    get :privacy_policy
    assert_response :success
  end

end
