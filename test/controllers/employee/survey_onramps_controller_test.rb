# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyOnrampsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
  end

  test 'survey onramps page' do
    get survey_onramps_url(@survey)
    assert_response :ok
  end
end
