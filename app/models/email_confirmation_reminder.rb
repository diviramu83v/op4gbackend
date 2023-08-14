# frozen_string_literal: true

# Reminders will be sent if the panelist doesn't confirm their email
class EmailConfirmationReminder < ApplicationRecord
  enum status: {
    waiting: 'waiting',
    sent: 'sent',
    ignored: 'ignored'
  }

  validates :status, presence: true

  scope :ready_to_send, -> { waiting.where('send_at < ?', Time.now.utc) }

  belongs_to :panelist

  def mark_as_ignored
    return unless waiting?

    update(status: EmailConfirmationReminder.statuses[:ignored])
  end

  def send_email
    PanelistMailer.email_confirmation_reminder(panelist).deliver_later
    mark_as_sent
  end

  private

  def mark_as_sent
    update(status: EmailConfirmationReminder.statuses[:sent])
  end
end
