# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyTestModesControllerTest < ActionDispatch::IntegrationTest
  describe '#update with survey test mode set to false' do
    setup do
      load_and_sign_in_admin
    end

    it 'should change the survey test mode to true' do
      patch survey_test_modes_url

      assert @employee.survey_test_mode.easy_mode?
    end
  end

  describe '#update with survey test mode set to true' do
    setup do
      load_and_sign_in_admin
      @employee.survey_test_mode.update!(easy_test: true)
    end

    it 'should change the survey test mode to false' do
      patch survey_test_modes_url

      assert_not @employee.survey_test_mode.easy_mode?
    end
  end
end
