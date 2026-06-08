# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name_or_email returns name when name is present' do
    assert_equal 'One', users(:one).name_or_email
  end

  test 'name_or_email returns email when name is blank' do
    assert_equal 'two@example.com', users(:two).name_or_email
  end
end
