# frozen_string_literal: true

require 'test_helper'

class ExpertRecruitBatchReminderJobTest < ActiveJob::TestCase
  setup do
    @expert_recruit_batch = expert_recruit_batches(:standard)
  end

  it 'is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: ExpertRecruitBatchReminderJob) do
      ExpertRecruitBatchReminderJob.perform_later(@expert_recruit_batch)
    end

    assert_enqueued_jobs 1
  end

  it 'updates reminders_finished_at' do
    survey = @expert_recruit_batch.survey
    survey.expert_recruits.create(email: 'test@testing', expert_recruit_batch: @expert_recruit_batch, description: @expert_recruit_batch.description,
                                  first_name: 'Test')
    ExpertRecruitBatchReminderJob.perform_now(@expert_recruit_batch)

    assert_not_nil @expert_recruit_batch.reminders_finished_at
  end
end
