# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'editable? returns true when target_user is owner' do
    report = reports(:one)
    assert report.editable?(users(:one))
  end

  test 'editable? returns false when target_user is not owner' do
    report = reports(:one)
    assert_not report.editable?(users(:two))
  end

  test 'created_on returns created_at date' do
    report = reports(:one)
    assert_equal report.created_at.to_date, report.created_on
  end

  test 'save_mentions adds mentioned reports from content' do
    report = reports(:one)
    mentioned_report = reports(:two)
    report.update!(
      content: "このレポートを参照します http://localhost:3000/reports/#{mentioned_report.id}"
    )
    assert_includes report.mentioning_reports.reload, mentioned_report
  end

  test 'save_mentions ignores self mention' do
    report = reports(:one)
    mentioned_report = reports(:one)
    report.update!(
      content: "自分のレポート http://localhost:3000/reports/#{mentioned_report.id}"
    )
    assert_empty report.mentioning_reports.reload, mentioned_report
  end

  test 'save_mentions does not duplicate same mentioned report' do
    report = reports(:one)
    mentioned_report = reports(:two)
    report.update!(
      content: "このレポートを参照します http://localhost:3000/reports/#{mentioned_report.id} \n このレポートを参照します http://localhost:3000/reports/#{mentioned_report.id}"
    )
    assert_equal [mentioned_report.id], report.mentioning_reports.reload.pluck(:id)
  end

  test 'save_mentions ignores non existing report id' do
    report = reports(:one)
    report.update!(
      content: '存在しないレポート http://localhost:3000/reports/999999'
    )
    assert_empty report.mentioning_reports.reload
  end

  test 'save_mentions replaces old mentions' do
    report = reports(:one)
    old_mentioned_report = reports(:two)
    new_mentioned_report = reports(:three)
    report.update!(
      content: "古いメンション http://localhost:3000/reports/#{old_mentioned_report.id}"
    )

    assert_includes report.mentioning_reports.reload, old_mentioned_report

    report.update!(
      content: "新しいメンション http://localhost:3000/reports/#{new_mentioned_report.id}"
    )
    assert_equal [new_mentioned_report.id], report.mentioning_reports.reload.pluck(:id)
  end
end
