# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyApiTargetActivationsControllerTest < ActionDispatch::IntegrationTest
  before do
    sign_in employees(:operations)
    @target = survey_api_targets(:standard)
    @survey = @target.survey
  end

  describe '#create' do
    it 'should switch the status to active' do
      @target.update!(status: SurveyApiTarget.statuses[:inactive])
      post survey_api_target_activations_url(@survey)
      @target.reload
      assert_equal SurveyApiTarget.statuses[:active], @target.status
      assert_redirected_to survey_api_target_url(@survey)
    end

    describe 'no age range selected' do
      setup { @target.update!(min_age: nil, max_age: nil) }

      it 'loads the page' do
        post survey_api_target_activations_url(@survey)
        assert_redirected_to survey_api_target_url(@survey)
      end
    end
  end

  describe '#destroy' do
    it 'should switch the status to inactive' do
      @target.update!(status: SurveyApiTarget.statuses[:active])
      delete survey_api_target_activations_url(@survey)
      @target.reload
      assert_equal SurveyApiTarget.statuses[:inactive], @target.status
    end

    describe 'no age range selected' do
      setup { @target.update!(min_age: nil, max_age: nil) }

      it 'loads the page' do
        post survey_api_target_activations_url(@survey)
        assert_redirected_to survey_api_target_url(@survey)
      end
    end
  end
end
