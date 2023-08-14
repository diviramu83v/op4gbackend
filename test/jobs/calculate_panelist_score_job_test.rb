# frozen_string_literal: true

require 'test_helper'

class CalculatePanelistScoreJobTest < ActiveJob::TestCase
  describe '#calculate_score' do
    setup do
      @panelist = panelists(:standard)
    end

    test 'is enqueued' do
      assert_no_enqueued_jobs
      assert_enqueued_with(job: CalculatePanelistScoreJob) do
        CalculatePanelistScoreJob.perform_later(panelist: @panelist)
      end
      assert_enqueued_jobs 1
    end

    test 'calls calculate_score' do
      PanelistScoreCalculator.any_instance.expects(:calculate!)
      CalculatePanelistScoreJob.perform_now(panelist: @panelist)
    end
  end
end
