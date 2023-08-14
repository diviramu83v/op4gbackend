# frozen_string_literal: true

# This job prepares expert recruit batch invitation reminder emails.
class ExpertRecruitBatchReminderJob < ApplicationJob
  queue_as :default

  def perform(expert_recruit_batch)
    expert_recruit_batch.send_reminders
  end
end
