# frozen_string_literal: true

# a record for a batch of completes that will be sent an incentive
class IncentiveBatch < ApplicationRecord
  enum status: {
    waiting: 'waiting',
    sent: 'sent'
  }

  belongs_to :employee

  has_many :incentive_recipients, dependent: :destroy

  validates :reward_cents, :survey_name, presence: true

  after_create :create_incentive_recipients

  monetize :reward_cents, allow_nil: true

  def send_rewards
    return false unless account_balance_enough?

    sent!
    CreateTangoOrdersJob.perform_later(self)
  end

  def account_balance_enough?
    TangoApi.new.account > total_cost
  end

  def total_cost
    incentive_recipients.count * reward.to_f
  end

  def create_incentive_recipients
    CreateIncentiveRecipientsJob.perform_later(self)
  end

  def sendable?
    waiting? && incentive_recipients.exists?
  end
end
