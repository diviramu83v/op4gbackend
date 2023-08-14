# frozen_string_literal: true

require 'test_helper'

class PullApiCintSingleYearCompletesDataJobTest < ActiveJob::TestCase
  setup do
    @completes_by_month = [[[2022, 1], 75, 538.0, 242.95, 295.05]]
  end

  it 'job is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: PullApiCintSingleYearCompletesDataJob) do
      PullApiCintSingleYearCompletesDataJob.perform_later(@completes_by_month)
    end

    assert_enqueued_jobs 1
  end

  it 'calls broadcast_to' do
    ApiCintSingleYearCompletesChannel.expects(:broadcast_to).once
    PullApiCintSingleYearCompletesDataJob.perform_now(@completes_by_month)
  end
end
