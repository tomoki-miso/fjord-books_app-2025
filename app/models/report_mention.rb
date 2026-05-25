# frozen_string_literal: true

class ReportMention < ApplicationRecord
  belongs_to :report, inverse_of: :report_mentions
  belongs_to :mentioned_report, class_name: 'Report'
  validates :mentioned_report_id, uniqueness: { scope: :report_id }
end
