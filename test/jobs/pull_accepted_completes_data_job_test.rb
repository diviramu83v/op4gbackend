# frozen_string_literal: true

require 'test_helper'

class PullAcceptedCompletesDataJobTest < ActiveJob::TestCase
  setup do
    @decoding = completes_decoders(:standard)
    @project = projects(:standard)
  end

  it 'job is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: PullAcceptedCompletesDataJob) do
      PullAcceptedCompletesDataJob.perform_later(@decoding, @project)
    end

    assert_enqueued_jobs 1
  end

  it 'calls broadcast_to' do
    AcceptedCompletesChannel.expects(:broadcast_to).once
    PullAcceptedCompletesDataJob.perform_now(@decoding, @project)
  end
end
