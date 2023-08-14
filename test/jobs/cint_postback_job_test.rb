# frozen_string_literal: true

require 'test_helper'

class CintPostbackJobTest < ActiveJob::TestCase
  setup do
    @onboarding = onboardings(:standard)
  end

  test 'is enqueued' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: CintPostbackJob) do
      CintPostbackJob.perform_later
    end

    assert_enqueued_jobs 1
  end

  test 'calls record_cint_response' do
    CintApi.any_instance.expects(:record_cint_response)
    CintPostbackJob.perform_now(onboarding: @onboarding)
  end
end
