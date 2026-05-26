# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'avatar can be attached' do
    user = users(:one)

    user.avatar.attach(
      io: File.open(Rails.root.join('test/fixtures/files/avatar.png')),
      filename: 'avatar.png',
      content_type: 'image/png'
    )

    assert user.avatar.attached?
  end

  test 'avatar thumb variant is defined' do
    user = users(:one)

    user.avatar.attach(
      io: File.open(Rails.root.join('test/fixtures/files/avatar.png')),
      filename: 'avatar.png',
      content_type: 'image/png'
    )

    assert user.avatar.variant(:thumb)
  end

  test 'name_or_email returns name when name is present' do
    assert_equal 'One', users(:one).name_or_email
  end

  test 'name_or_email returns email when name is blank' do
    assert_equal 'two@example.com', users(:two).name_or_email
  end
end
