# frozen_string_literal: true

require 'test_helper'

class PullApiCintCompletesDataJobTest < ActiveJob::TestCase
  setup do
    @years = (2021..Time.zone.now.year).to_a
  end

  it 'job is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: PullApiCintCompletesDataJob) do
      PullApiCintCompletesDataJob.perform_later(@years)
    end

    assert_enqueued_jobs 1
  end

  it 'calls broadcast_to' do
    ApiCintCompletesChannel.expects(:broadcast_to).once
    PullApiCintCompletesDataJob.perform_now(@years)
  end
end
