require 'test_helper'

class V1::StationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_stations_index_url
    assert_response :success
  end

end
