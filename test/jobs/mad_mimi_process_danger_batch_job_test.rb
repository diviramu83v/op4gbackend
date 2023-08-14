# frozen_string_literal: true

require 'test_helper'

class MadMimiProcessDangerBatchJobTest < ActiveJob::TestCase
  test 'enqueue the job' do
    assert_no_enqueued_jobs
    assert_enqueued_with(job: MadMimiProcessDangerBatchJob) do
      MadMimiProcessDangerBatchJob.perform_later
    end
    assert_enqueued_jobs 1
  end

  test 'perform the job' do
    Panelist.expects(:process_endangered_panelists).once
    MadMimiProcessDangerBatchJob.perform_now
  end
end
