# frozen_string_literal: true

require 'test_helper'

class MadMimiSuppressEmailJobTest < ActiveJob::TestCase
  setup do
    @email = 'testing@123.com'
  end

  test 'enqueue the job' do
    assert_no_enqueued_jobs
    assert_enqueued_with(job: MadMimiSuppressEmailJob) do
      MadMimiSuppressEmailJob.perform_later(email: @email)
    end
    assert_enqueued_jobs 1
  end

  test 'perform the job' do
    MadMimiApi.any_instance.expects(:suppress_all_communication).once
    MadMimiSuppressEmailJob.perform_now(email: @email)
  end
end
