# frozen_string_literal: true

require 'test_helper'

class SurveyWarningJobTest < ActiveJob::TestCase
  setup do
    @survey = surveys(:standard)
  end

  it 'enqueues a survey warning job' do
    assert_difference -> { @survey.survey_warnings.count }, 1 do
      SurveyWarningJob.perform_now
    end
  end
end
