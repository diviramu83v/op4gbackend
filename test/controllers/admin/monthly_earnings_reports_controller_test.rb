# frozen_string_literal: true

require 'test_helper'

class Admin::MonthlyEarningsReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_employee = employees(:admin)
    sign_in @admin_employee

    @this_month = Time.now.utc.strftime('%m')
    @this_year = Time.now.utc.strftime('%Y')
    @earning = earnings(:one)
    @earning.update(period: "#{@this_year}-#{@this_month}", period_year: @this_year.to_s)
  end

  it 'shows the index view' do
    get monthly_earnings_report_url

    assert_response :ok
    assert_template :show
  end

  it 'returns the populated results view' do
    get monthly_earnings_report_url

    assert_response :ok
  end

  it 'returns a csv of the results' do
    get monthly_earnings_report_url(format: :csv)

    assert_response :ok
  end
end
