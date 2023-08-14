# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyTargetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'update a survey target via the inline form' do
    @survey = surveys(:standard)
    patch survey_target_url(@survey), params: { survey: { target: 100 } }, xhr: true

    assert_ok_with_no_warning
  end
end
