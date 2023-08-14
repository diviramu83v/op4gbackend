# frozen_string_literal: true

# This job sends out expert recruit batch invitation reminder emails.
class ExpertRecruitReminderDeliveryJob < ApplicationJob
  queue_as :default

  def perform(expert_recruit)
    expert_recruit.send_survey_invite_reminder
  end
end
