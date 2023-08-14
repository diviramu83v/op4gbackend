# frozen_string_literal: true

# PanelistStatus encapsulates the panelist methods involving Panelist status changes
# rubocop:disable Metrics/ModuleLength
module PanelistFinance
  include ActiveSupport::Concern

  def legacy_earnings
    return nil if legacy_earnings_cents.blank?

    legacy_earnings_cents.to_d / 100
  end

  def legacy_earnings=(amount)
    return if amount.blank?
    return unless amount.to_s.numeric?

    self[:legacy_earnings_cents] = (amount.to_d * 100).round
  end

  # In dollars.
  def balance
    calculation = legacy_earnings + total_earnings - total_payments
    calculation.positive? ? calculation : 0
  end

  # In dollars.
  def balance_excluding_period(period)
    calculation = legacy_earnings + total_earnings_excluding_period(period) - total_payments_excluding_period(period)
    calculation.positive? ? calculation : 0
  end

  # In dollars.
  def balance_through_last_month
    calculation = legacy_earnings + total_earnings_for_last_month - total_payments_for_last_month
    calculation.positive? ? calculation : 0
  end

  # In dollars.
  def earnings_this_month
    total_earnings_for_this_month
  end

  def met_minimum_balance_last_month?
    balance_through_last_month >= Payment::MINIMUM_PAYOUT_IN_DOLLARS
  end

  def payout_funds_needed
    current_amount = Payment::MINIMUM_PAYOUT_IN_DOLLARS - balance
    return 0 if current_amount.negative?

    current_amount
  end

  def monthly_earnings_needed
    current_amount = Payment::MINIMUM_PAYOUT_IN_DOLLARS - total_earnings_for_this_month
    return 0 if current_amount.negative?

    current_amount
  end

  def donation_total_this_quarter
    active_earnings.where(period: PeriodCalculator.current_quarter_periods).sum(&:nonprofit_amount)
  end

  def active_financial_period_years
    earnings_years = active_earnings.distinct(:period_year).order('period_year DESC').pluck(:period_year)
    payments_years = active_payments.distinct(:period_year).order('period_year DESC').pluck(:period_year)
    (earnings_years + payments_years).uniq.sort.reverse
  end

  def combined_earnings_and_payments_for_year(year)
    yearly_earnings = active_earnings.where(period_year: year)
    yearly_payments = active_payments.where(period_year: year)

    combined_records = yearly_earnings + yearly_payments

    combined_records.sort_by { |r| [r.period, r.class.name] }.reverse
  end

  def contributing_to_nonprofit?
    nonprofit.present? && donation_percentage.positive?
  end

  def supporting_nonprofit?
    nonprofit.present?
  end

  def add_signup_earnings
    return if earnings.incentive.any?

    if campaign.present?
      add_campaign_signup_earnings
    elsif primary_panel.present?
      add_panel_signup_earnings
    end
  end

  private

  def add_campaign_signup_earnings
    incentive = campaign.incentive
    return unless incentive&.positive?

    earnings.create!(campaign: campaign, total_amount: incentive)
  end

  def add_panel_signup_earnings
    incentive = primary_panel.incentive
    return unless incentive&.positive?

    earnings.create!(panel: primary_panel, total_amount: incentive)
  end

  def active_earnings
    earnings.active
  end

  def total_earnings
    active_earnings.sum(&:panelist_amount)
  end

  def total_earnings_for_this_month
    active_earnings.where(period: PeriodCalculator.current_period).sum(&:panelist_amount)
  end

  def total_earnings_excluding_period(period)
    active_earnings.where.not(period: period).sum(&:panelist_amount)
  end

  def active_payments
    payments.active
  end

  def total_payments
    active_payments.sum(&:amount)
  end

  def total_payments_excluding_period(period)
    active_payments.where.not(period: period).sum(&:amount)
  end

  def total_earnings_for_last_month
    total_earnings_excluding_period(PeriodCalculator.current_period)
  end

  def total_payments_for_last_month
    total_payments_excluding_period(PeriodCalculator.current_period)
  end

  def set_donation_percentage
    if nonprofit.present?
      # Set default, but only if not already set.
      self.donation_percentage = 100 if donation_percentage.zero?
    else
      self.donation_percentage = 0
    end
  end
end
# rubocop:enable Metrics/ModuleLength
