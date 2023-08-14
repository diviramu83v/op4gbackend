# frozen_string_literal: true

# A payment to a specific panelist. Likely covers multiple earnings.
class Payment < ApplicationRecord
  belongs_to :panelist
  belongs_to :payment_upload_batch, optional: true

  MINIMUM_PAYOUT_IN_DOLLARS = 10

  # TODO: Handle voided payments.
  # TODO: Is paid_at the same as created_at?

  before_validation :set_period, :set_period_year

  validates :period, :period_year, :paid_at, presence: true
  validates :amount, numericality: { greater_than: 0 }

  scope :active, -> { where.not(paid_at: nil).where(voided_at: nil).where(hidden_at: nil) }

  def ledger_amount
    -1 * amount
  end

  def amount
    return nil if amount_cents.blank?

    amount_cents.to_d / 100
  end

  def amount=(amount)
    return if amount.blank?
    return unless amount.to_s.numeric?

    self[:amount_cents] = (amount.to_d * 100).round
  end

  def self.next_payout_date
    Time.now.utc.at_beginning_of_month.next_month
  end

  def self.current_months_payout_date
    (Time.now.utc + 2.months).at_beginning_of_month
  end

  def ledger_description
    'Payment'
  end

  private

  def set_period
    return if period.present?

    self.period = PeriodCalculator.current_period
  end

  def set_period_year
    return if period_year.present?

    self.period_year = PeriodCalculator.current_period_year
  end
end
