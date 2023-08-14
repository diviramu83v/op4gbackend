# frozen_string_literal: true

require 'test_helper'

class MadMimiAddToDangerListJobTest < ActiveJob::TestCase
  setup do
    @panelist = panelists(:active)
  end

  test 'enqueue the job' do
    assert_no_enqueued_jobs
    assert_enqueued_with(job: MadMimiAddToDangerListJob) do
      MadMimiAddToDangerListJob.perform_later(panelist: @panelist)
    end
    assert_enqueued_jobs 1
  end

  test 'perform the job' do
    Panelist.any_instance.expects(:add_to_danger_list).once
    MadMimiAddToDangerListJob.perform_now(panelist: @panelist)
  end
end
