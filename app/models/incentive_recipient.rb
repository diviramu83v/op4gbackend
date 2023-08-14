# frozen_string_literal: true

# an incentive recipient receives the tango incentive from incentive batch
class IncentiveRecipient < ApplicationRecord
  belongs_to :incentive_batch

  enum status: {
    initialized: 'initialized',
    sent: 'sent',
    error: 'error'
  }

  def set_to_sent
    sent!

    update(sent: true)
  end
end
