# frozen_string_literal: true

require 'test_helper'

class Employee::FollowupSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
  end

  it 'view followup data step' do
    get survey_followup_surveys_url(@survey, format: :html)

    assert_response :ok
  end

  it 'download followup data csv' do
    get survey_followup_surveys_url(@survey, format: :csv)

    assert_response :ok
  end
end
