# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  # rubocop:disable Rails/SkipsModelValidations
  describe '#create' do
    setup do
      @survey = surveys(:standard)
      @survey.update_column(:status, 'draft')
    end

    it 'should change the status of a the survey from draft to live' do
      post survey_statuses_url(@survey, status: 'live')
      @survey.reload

      assert_equal 'live', @survey.status
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
