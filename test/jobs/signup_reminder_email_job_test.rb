# frozen_string_literal: true

require 'test_helper'

class SignupReminderEmailJobTest < ActiveJob::TestCase
  setup do
    @signup_reminder = signup_reminder(:standard)
    @signup_reminder_two = signup_reminder(:standard)
  end

  it 'enqueues a survey warning job' do
    @signup_reminder_two.update!(send_at: Time.now.utc - 1.minute)
    @signup_reminder_two.save!

    assert_difference -> { SignupReminder.sent.count }, 1 do
      SignupReminderEmailJob.perform_now
    end
  end
end
