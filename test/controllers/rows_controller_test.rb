require 'test_helper'

class RowsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rows_index_url
    assert_response :success
  end

end
