require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get indec' do
    get users_indec_url
    assert_response :success
  end
end
