# frozen_string_literal: true

class ReportMention < ApplicationRecord
  belongs_to :report, inverse_of: :report_mentions
  belongs_to :mentioning_report, class_name: 'Report', inverse_of: :report_mentions
end
