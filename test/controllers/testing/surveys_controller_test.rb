# frozen_string_literal: true

require 'test_helper'

class Testing::SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'show invitation test page' do
    @survey = surveys(:standard)
    @onboarding = onboardings(:standard)

    get test_survey_url(@survey.token, uid: @onboarding.token)

    assert_ok_with_no_warning
  end
end
