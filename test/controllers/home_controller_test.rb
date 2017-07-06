require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get dbupload" do
    get home_dbupload_url
    assert_response :success
  end

  test "should get choose" do
    get home_choose_url
    assert_response :success
  end

  test "should get average" do
    get home_average_url
    assert_response :success
  end

  test "should get five_inning" do
    get home_five_inning_url
    assert_response :success
  end

end
