# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyAdjustmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
    @params = { survey_adjustment: { client_count: 100 } }
  end

  describe '#new' do
    test 'response' do
      get new_survey_adjustment_url(@survey)
      assert_response :ok
      assert_select 'h2', count: 1, text: 'Adjust complete count'
    end
  end

  describe '#create' do
    test 'standard behavior' do
      assert_difference -> { @survey.adjustments.count } do
        post survey_adjustments_url(@survey), params: @params
      end
      assert_redirected_to survey_url(@survey)
      assert_not_nil flash[:notice]
    end

    test 'failure to save' do
      SurveyAdjustment.any_instance.expects(:save).returns(false)

      assert_no_difference -> { @survey.adjustments.count } do
        post survey_adjustments_url(@survey), params: @params
      end
      assert_response :ok
      assert_select 'h2', count: 1, text: 'Adjust complete count'
    end
  end

  describe '#new + #create' do
    test 'start from survey page' do
      get new_survey_adjustment_url(@survey, return_url: survey_url(@survey))
      post survey_adjustments_url(@survey), params: @params
      assert_redirected_to survey_url(@survey)
    end

    test 'start from project page' do
      get new_survey_adjustment_url(@survey, return_url: project_url(@survey.project, anchor: "survey-#{@survey.id}"))
      post survey_adjustments_url(@survey), params: @params
      assert_redirected_to project_url(@survey.project, anchor: "survey-#{@survey.id}")
    end
  end
end
