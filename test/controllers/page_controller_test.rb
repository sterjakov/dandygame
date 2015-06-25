require 'test_helper'

class PageControllerTest < ActionController::TestCase
  test "should get not_found" do
    get :not_found
    assert_response :success
  end

end
