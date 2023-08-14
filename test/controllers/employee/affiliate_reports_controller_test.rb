# frozen_string_literal: true

require 'test_helper'

class Employee::AffiliateReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:admin)
  end

  describe '#new' do
    it 'should load the new page' do
      get new_affiliate_report_url
      assert_response :ok
    end
  end

  describe '#show' do
    it 'should load the show page' do
      get affiliate_report_url
      assert_response :ok
    end

    test 'flash alert when end date is before start date' do
      get affiliate_report_url, params: {
        period_selector: {
          start_period: DateTime.now,
          end_period: DateTime.now - 30
        }
      }

      assert_equal 'Start period can\'t be after end period', flash[:alert]
    end
  end
end
