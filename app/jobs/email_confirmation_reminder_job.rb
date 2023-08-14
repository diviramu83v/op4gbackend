# frozen_string_literal: true

# Checks for surveys that are live with no sent batches
class EmailConfirmationReminderJob < ApplicationJob
  queue_as :default

  def perform
    EmailConfirmationReminder.ready_to_send.find_each(&:send_email)
  end
end
