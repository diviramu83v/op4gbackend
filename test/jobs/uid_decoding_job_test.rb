# frozen_string_literal: true

require 'test_helper'

class UidDecodingJobTest < ActiveJob::TestCase
  setup do
    @decoding = decodings(:standard)
  end

  test 'enqueued properly' do
    assert_no_enqueued_jobs
    assert_enqueued_with(job: UidDecodingJob) do
      UidDecodingJob.perform_later @decoding
    end
    assert_enqueued_jobs 1
  end

  test 'sends message to Decoding class' do
    @decoding.expects(:decode_uids).once
    UidDecodingJob.perform_now @decoding
  end
end
