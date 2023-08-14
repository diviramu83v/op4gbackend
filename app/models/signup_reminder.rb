# frozen_string_literal: true

# A record that will be removed once a panelist completes signup.
# These records mean the panelist is eligible for signup reminder emails.
class SignupReminder < ApplicationRecord
  belongs_to :panelist

  scope :ready_to_send, -> { waiting.where('send_at < ?', Time.now.utc) }

  enum status: {
    waiting: 'waiting',
    sent: 'sent',
    ignored: 'ignored'
  }

  validates :status, presence: true

  def send_email
    PanelistMailer.demographic_completion_reminder(panelist).deliver_later
    sent!
  end
end
