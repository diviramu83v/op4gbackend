# frozen_string_literal: true

# A record of a panelist's compensation for completing an activity. Includes
#   total amount earned, plus the panelist/nonprofit split amounts.
class Earning < ApplicationRecord
  enum category: {
    ambassador: 'ambassador'
  }

  belongs_to :panelist
  belongs_to :earnings_batch, optional: true
  belongs_to :onboarding, optional: true
  belongs_to :sample_batch, optional: true
  belongs_to :nonprofit, optional: true
  belongs_to :campaign, optional: true, class_name: 'RecruitingCampaign', inverse_of: :earnings
  belongs_to :panel, optional: true
  belongs_to :vendor, optional: true, inverse_of: :earnings

  has_one :project, through: :sample_batch

  before_validation :set_nonprofit, :set_period, :set_period_year, :split_total_amount

  validates :period, :period_year, presence: true
  validates :total_amount, numericality: { greater_than: 0 }
  validates :panelist_amount, :nonprofit_amount, numericality: { greater_than_or_equal_to: 0 }
  validate :split_amounts_add_up_to_total
  validate :nonprofit_required_if_nonprofit_amount_present

  scope :active, -> { where(hidden_at: nil) }
  scope :incentive, -> { where('campaign_id IS NOT NULL OR panel_id IS NOT NULL') }

  def original_uid
    onboarding.try(:uid)
  end

  def total_amount
    return if total_amount_cents.blank?

    total_amount_cents.to_d / 100
  end

  def total_amount=(amount)
    return if amount.blank?
    return unless amount.to_s.numeric?

    self[:total_amount_cents] = (amount.to_d * 100).round
  end

  def panelist_amount
    return if panelist_amount_cents.blank?

    panelist_amount_cents.to_d / 100
  end
  alias ledger_amount panelist_amount

  def panelist_amount=(amount)
    return if amount.blank?
    return unless amount.to_s.numeric?

    self[:panelist_amount_cents] = (amount.to_d * 100).round
  end

  def nonprofit_amount
    return if nonprofit_amount_cents.blank?

    nonprofit_amount_cents.to_d / 100
  end

  def nonprofit_amount=(amount)
    return if amount.blank?
    return unless amount.to_s.numeric?

    self[:nonprofit_amount_cents] = (amount.to_d * 100).round
  end

  def ledger_description
    return "(#{project&.id}) Credit: #{sample_batch.email_subject}" if sample_batch.present?
    return 'Credit: demographics profile completion' if incentive?
    return 'Credit: ambassador program' if ambassador?

    'Credit: legacy survey'
  end

  private

  def incentive?
    campaign.present? || panel.present?
  end

  def set_nonprofit
    return if nonprofit.present?

    self.nonprofit = panelist.try(:nonprofit)
  end

  def set_period
    return if period.present?

    self.period = PeriodCalculator.current_period
  end

  def set_period_year
    return if period_year.present?

    self.period_year = PeriodCalculator.current_period_year
  end

  # rubocop:disable Metrics/AbcSize
  def split_total_amount
    return if total_amount.blank? || total_amount.zero? || panelist_amount.positive? || nonprofit_amount.positive?

    if nonprofit.nil? || panelist.donation_percentage.zero?
      self.panelist_amount = total_amount
    else
      self.nonprofit_amount = total_amount * panelist.donation_percentage / 100
      self.panelist_amount = total_amount - nonprofit_amount
    end
  end
  # rubocop:enable Metrics/AbcSize

  def nonprofit_required_if_nonprofit_amount_present
    return if nonprofit_amount.blank? || nonprofit_amount.zero?

    errors.add(:nonprofit, 'is required when nonprofit amount present') if nonprofit.blank?
  end

  def split_amounts_add_up_to_total
    return if panelist_amount + nonprofit_amount == total_amount

    errors.add(:base, 'The panelist amount and nonprofit amount must add up to the total earning amount')
  end
end
