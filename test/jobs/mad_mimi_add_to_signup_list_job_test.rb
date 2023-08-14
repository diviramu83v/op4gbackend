# frozen_string_literal: true

require 'test_helper'

class MadMimiAddToSignupListJobTest < ActiveJob::TestCase
  setup do
    @panelist = panelists(:active)
  end

  test 'enqueue the job' do
    assert_no_enqueued_jobs
    assert_enqueued_with(job: MadMimiAddToSignupListJob) do
      MadMimiAddToSignupListJob.perform_later(panelist: @panelist)
    end
    assert_enqueued_jobs 1
  end

  test 'perform the job' do
    Panelist.any_instance.expects(:add_to_signup_list).once
    MadMimiAddToSignupListJob.perform_now(panelist: @panelist)
  end
end
