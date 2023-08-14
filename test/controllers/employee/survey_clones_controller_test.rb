# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyClonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
    @survey = surveys(:standard)
  end

  describe '#create' do
    it 'should clone the survey' do
      assert_difference -> { Survey.count }, 1 do
        post survey_clone_url(@survey)
      end

      assert_not_nil flash[:notice]
      assert_redirected_to project_url(@survey.project)
    end
  end
end
