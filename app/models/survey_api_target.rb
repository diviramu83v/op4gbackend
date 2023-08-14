# frozen_string_literal: true

# SurveyApiTarget describes the targets for a survey that is made available via the API
class SurveyApiTarget < ApplicationRecord
  include SurveyApiTargetSelections

  enum status: {
    active: 'active',
    inactive: 'inactive',
    sandbox: 'sandbox'
  }

  belongs_to :survey

  validates :countries, :status, presence: true
  validates :payout, presence: true, numericality: { greater_than: 0 }
  validate :age_range_must_be_valid

  before_save :set_age_range
  after_commit :add_onramps, on: [:create, :update]

  def not_active?
    !active?
  end

  def add_onramps
    if active?
      ApiToken.active_vendors.each do |vendor|
        add_onramp_for_vendor(vendor)
      end
    elsif sandbox?
      ApiToken.sandbox_vendors.each do |vendor|
        add_onramp_for_vendor(vendor)
      end
    end
  end

  def add_onramp_for_vendor(vendor)
    return if api_onramp_exists_for_vendor?(vendor)

    Onramp.create!(
      survey: survey,
      category: Onramp.categories[:api],
      api_vendor: vendor,
      check_clean_id: true,
      check_recaptcha: true,
      check_gate_survey: false
    )
  end

  def min_age
    @min_age || age_range&.first.presence || MIN_AGE
  end

  def min_age=(age)
    @min_age = translate_age_from_string(value: age, default: MIN_AGE)
  end

  def max_age
    @max_age || age_range&.last.presence || MAX_AGE
  end

  def max_age=(age)
    @max_age = translate_age_from_string(value: age, default: MAX_AGE)
  end

  def payout
    return nil if payout_cents.blank?

    payout_cents.to_d / 100
  end

  def payout=(amount)
    return if amount.blank?
    return unless amount.to_s.numeric?

    self[:payout_cents] = (amount.to_d * 100).round
  end

  private

  def api_onramp_exists_for_vendor?(vendor)
    survey.onramps.api.for_api_vendor(vendor).any?
  end

  def age_range_must_be_valid
    return if min_age.nil? || max_age.nil?

    errors.add(:base, 'Maximum age must be greater than minimum age') if min_age >= max_age
  end

  def set_age_range
    new_ages = (min_age..max_age).to_a

    all_possible_ages = (MIN_AGE..MAX_AGE).to_a

    self.age_range = if new_ages == all_possible_ages
                       nil
                     else
                       new_ages
                     end
  end

  def translate_age_from_string(value:, default:)
    return default if value.blank?
    return default unless value.integer?
    return default unless value.to_i.positive?

    value.to_i
  end

  def max_age?
    max_age.present? && max_age != MAX_AGE
  end

  def min_age?
    min_age.present? && min_age != MIN_AGE
  end
end
