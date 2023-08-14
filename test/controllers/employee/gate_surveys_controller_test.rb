# frozen_string_literal: true

require 'test_helper'

class Employee::GateSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
  end

  it 'view gate data step' do
    get survey_gate_surveys_url(@survey, format: :html)

    assert_response :ok
  end

  it 'download gate survey data csv' do
    get survey_gate_surveys_url(@survey, format: :csv)

    assert_response :ok
  end
end
