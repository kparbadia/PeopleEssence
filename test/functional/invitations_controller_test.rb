require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get contact_list" do
    get :contact_list
    assert_response :success
  end

end
