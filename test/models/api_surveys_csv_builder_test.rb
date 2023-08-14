# frozen_string_literal: true

require 'test_helper'

class ApiSurveysCsvBuilderTest < ActiveSupport::TestCase
  describe 'build_surveys_csv' do
    it 'builds the csv with the correct data for completes' do
      vendor = vendors(:api)

      onramp = onramps(:api)
      onramp.api_vendor = vendor
      onramp.save!

      onboarding = onboardings(:complete)
      onboarding.onramp = onramp
      onboarding.save!

      csv = ApiSurveysCsvBuilder.build_api_surveys_csv(vendor)

      assert_equal true, csv.lines.count > 1
    end

    it 'builds the csv with the correct data for fraud/rejected' do
      date = 3.months.ago
      vendor = vendors(:api)

      onramp = onramps(:api)
      onramp.api_vendor = vendor
      onramp.save!

      onboarding = onboardings(:complete)
      onboarding.created_at = date
      onboarding.client_status = 'fraudulent'
      onboarding.onramp = onramp
      onboarding.save!

      csv = ApiSurveysCsvBuilder.build_api_surveys_csv(vendor, date: date, completes: false)

      assert_equal true, csv.lines.count > 1
    end
  end
end
