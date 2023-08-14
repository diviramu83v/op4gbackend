# frozen_string_literal: true

require 'test_helper'

class EmailConfirmationReminderJobTest < ActiveJob::TestCase
  describe 'there are some unconfirmed panelists over 48 hours old' do
    setup do
      EmailConfirmationReminder.create(
        panelist: panelists(:standard),
        status: EmailConfirmationReminder.statuses[:waiting],
        send_at: Time.now.utc - 1.minute
      )
    end

    it 'should send email reminders with a sent date before now' do
      assert_difference -> { EmailConfirmationReminder.sent.count } do
        EmailConfirmationReminderJob.perform_now
      end
    end
  end
end
