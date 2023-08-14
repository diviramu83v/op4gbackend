# frozen_string_literal: true

require 'test_helper'

class CalculatePanelistScorePercentileJobTest < ActiveJob::TestCase
  test 'is enqueued' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: CalculatePanelistScorePercentileJob) do
      CalculatePanelistScorePercentileJob.perform_later
    end

    assert_enqueued_jobs 1
  end

  test 'calls calculate_score_percentile' do
    PanelistScorePercentileCalculator.any_instance.expects(:calculate!)
    CalculatePanelistScorePercentileJob.perform_now
  end
end
