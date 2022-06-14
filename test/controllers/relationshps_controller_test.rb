require "test_helper"

class RelationshpsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get relationshps_create_url
    assert_response :success
  end

  test "should get destroy" do
    get relationshps_destroy_url
    assert_response :success
  end
end
