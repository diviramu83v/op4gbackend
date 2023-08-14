# frozen_string_literal: true

# View helpers for survey batches.
module SampleBatchHelper
  # rubocop:disable Metrics/MethodLength
  def sample_batch_reminders_tooltip(batch)
    return if batch.remindable?

    if !batch.sent?
      "Invitations haven't been sent yet."
    elsif batch.reminders_sent?
      "Reminders sent: #{batch.reminders_finished_at.strftime('%F')}"
    elsif batch.reminders_queued?
      "Reminders started: #{batch.reminders_started_at.strftime('%F')}"
    elsif !batch.one_day_passed?
      'Please wait until 24 hours after the invitations have been sent to send reminders.'
    else
      'Reminders cannot be sent for this batch.'
    end
  end
  # rubocop:enable Metrics/MethodLength

  def sample_batch_reminders_tooltip_on?(batch)
    sample_batch_reminders_tooltip(batch).present?
  end
end
