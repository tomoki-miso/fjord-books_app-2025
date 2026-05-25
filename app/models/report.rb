# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_URL_REGEXP = %r{http://localhost:3000/reports/(\d+)}
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentions, dependent: :destroy, inverse_of: :report
  has_many :mentioning_reports, through: :report_mentions, source: :mentioned_report
  has_many :mentioned_report_mentions,
           class_name: 'ReportMention',
           foreign_key: :mentioned_report_id,
           dependent: :destroy,
           inverse_of: :mentioning_report
  has_many :mentioned_reports,
           through: :mentioned_report_mentions,
           source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def sync_report_mentions!
    transaction do
      mentioned_report_ids = extract_mentioned_report_ids(content).uniq
      existing_report_ids = Report.where(id: mentioned_report_ids).pluck(:id)

      report_mentions.destroy_all

      existing_report_ids.each do |mentioned_report_id|
        report_mentions.create!(mentioned_report_id: mentioned_report_id)
      end
    end
  end

  def extract_mentioned_report_ids(content)
    content.to_s.scan(REPORT_URL_REGEXP).flatten.map(&:to_i).uniq
  end
end
