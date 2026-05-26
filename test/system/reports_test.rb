# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)
    sign_in users(:one)
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '登録'

    assert_text '日報が作成されました。'
    click_on '日報の一覧に戻る'
  end

  test 'should not create report without title' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in '内容', with: @report.content
    click_on '登録'

    assert_text '1件のエラーがあるため、この日報は保存できませんでした:'
    assert_text 'タイトルを入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should not create report without content' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    click_on '登録'

    assert_text '1件のエラーがあるため、この日報は保存できませんでした:'
    assert_text '内容を入力してください'
    click_on '日報の一覧に戻る'
  end

  test 'should display mentiond reports' do
    mentioned_report = reports(:two)
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: "このレポートを参照します http://localhost:3000/reports/#{mentioned_report.id}"
    click_on '登録'

    assert_text '日報が作成されました。'
    click_on '日報の一覧に戻る'

    visit report_url(reports(:two))

    assert_selector 'strong', text: 'この日報に言及している日報:'
    assert_selector 'li', text: mentioned_report.title
  end

  test 'should not update others Report' do
    visit report_url(reports(:two))
    assert_no_text 'この日報を編集'
  end

  test 'should not delete others Report' do
    visit report_url(reports(:two))
    assert_no_text 'この日報を削除'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '更新する'

    assert_text '日報が更新されました。'
    click_on '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
  end
end
