# frozen_string_literal: true

require 'test_helper'

class SignupReminderTest < ActiveSupport::TestCase
  subject { SignupReminder.new }

  describe 'public methods' do
    it 'respond' do
      assert_respond_to subject, :send_email
    end
  end

  describe '#send_email?' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'sends the email and marks the SignupReminder as sent' do
      subject.update!(panelist: @panelist)

      mock_mailer = mock('mailer')
      mock_mailer.expects(:deliver_later)
      PanelistMailer.expects(:demographic_completion_reminder).returns(mock_mailer)

      assert subject.waiting?

      subject.send_email

      assert subject.sent?
    end
  end
end
