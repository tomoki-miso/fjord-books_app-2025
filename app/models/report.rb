# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user

  def owner?(current_user)
    user_id == current_user.id
  end
end
