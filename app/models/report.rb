# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_URL_REGEXP = %r{http://localhost:3000/reports/(\d+)}
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentions, dependent: :destroy
  has_many :mentioned_reports, through: :report_mentions, source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def extract_mentioned_report_ids(content)
    content.to_s.scan(REPORT_URL_REGEXP).flatten.map(&:to_i).uniq
  end
end
