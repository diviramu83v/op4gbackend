# frozen_string_literal: true

# Send reminder emails about signing up
class SignupReminderEmailJob < ApplicationJob
  queue_as :default

  def perform
    SignupReminder.ready_to_send.find_each(&:send_email)
  end
end
