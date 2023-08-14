# frozen_string_literal: true

require 'test_helper'

class PullTrafficDataJobTest < ActiveJob::TestCase
  setup do
    @survey = surveys(:standard)
  end

  it 'job is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: PullTrafficDataJob) do
      PullTrafficDataJob.perform_later(@survey)
    end

    assert_enqueued_jobs 1
  end

  it 'calls broadcast_to' do
    TrafficDataChannel.expects(:broadcast_to).once
    PullTrafficDataJob.perform_now(@survey)
  end
end
