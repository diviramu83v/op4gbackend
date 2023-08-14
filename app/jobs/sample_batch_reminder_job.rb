# frozen_string_literal: true

# The job that sends out survey invitations. These jobs run in their own queue.
class SampleBatchReminderJob < ApplicationJob
  queue_as :default

  def perform(sample_batch, current_employee)
    sample_batch.send_reminders(current_employee)
  end
end
