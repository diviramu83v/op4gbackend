# frozen_string_literal: true

require 'test_helper'

class ExpertRecruitReminderDeliveryJobTest < ActiveJob::TestCase
  setup do
    @expert_recruit = expert_recruits(:standard)
  end

  it 'is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: ExpertRecruitReminderDeliveryJob) do
      ExpertRecruitReminderDeliveryJob.perform_later(@expert_recruit)
    end

    assert_enqueued_jobs 1
  end
end
