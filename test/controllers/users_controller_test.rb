# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  setup do
    login_as(users(:one), scope: :user)
  end
  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get show' do
    get users_url(users(:one))
    assert_response :success
  end
end
