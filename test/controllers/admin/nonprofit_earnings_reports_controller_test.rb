# frozen_string_literal: true

require 'test_helper'

class Admin::NonprofitEarningsReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_employee = employees(:admin)
    sign_in @admin_employee

    @this_month = Time.now.utc.strftime('%B')
    @this_year = Time.now.utc.strftime('%Y')
    @earning = earnings(:one)
    @earning.update(period: "#{@this_year}-#{@this_month}", period_year: @this_year.to_s)
  end

  it 'shows the month selection view' do
    get nonprofit_earnings_report_url,
        params: { start_year: { start_year: @this_year }, end_year: { end_year: @this_year }, start_month: @this_month,
                  end_month: @this_month }

    assert_response :ok
    assert_template :show
  end

  it 'rerenders the show view and warn if the beginning month is not before the ending month' do
    @last_year = (Time.now.utc - 1.year).strftime('%Y')
    post nonprofit_earnings_report_url,
         params: { start_year: { start_year: @this_year }, end_year: { end_year: @last_year }, start_month: @this_month,
                   end_month: @this_month }

    assert_response :ok
    assert_template :show
    assert_not_nil flash[:alert]
  end

  it 'returns the populated report view' do
    post nonprofit_earnings_report_url,
         params: { start_year: { start_year: @this_year }, end_year: { end_year: @this_year }, start_month: @this_month,
                   end_month: @this_month }

    assert_response :ok
    assert_template :show
  end

  it 'returns the populated report csv' do
    mock_result = mock('result')
    mock_result.stubs(:rows).returns([[123, 'abc'], [111, 'a-aa']])
    Nonprofit.expects(:generate_earnings_report).returns(mock_result)

    post nonprofit_earnings_report_url,
         params: { generate_csv: 'anything', start_year: { start_year: @this_year }, end_year: { end_year: @this_year },
                   start_month: @this_month, end_month: @this_month }

    assert_response :ok
    assert_equal 'text/csv', response.content_type
  end
end
