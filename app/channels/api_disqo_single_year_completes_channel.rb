# frozen_string_literal: true

# Download vendor block rate report data.
class ApiDisqoSingleYearCompletesChannel < ApplicationCable::Channel
  def subscribed # rubocop:disable Metrics/AbcSize
    Rails.logger.debug 'Subscribed to the API Disqo single year completes channel.'
    onboarding_ids = params[:onboarding_ids]
    onboardings = onboarding_ids.map { |id| Onboarding.find(id) }
    @completes_by_month = onboardings.group_by { |o| [o.created_at.year, o.created_at.month] }.sort.reverse.to_h
    @completes_by_month = add_totals_to_hash
    PullApiDisqoSingleYearCompletesDataJob.perform_later(@completes_by_month)
    completes_by_month = @completes_by_month

    stream_for completes_by_month
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the API Disqo single year completes channel.'
  end

  private

  def add_totals_to_hash
    @completes_by_month.map do |date, completes|
      completes = completes.count
      revenue = Onboarding.disqo_completes_revenue_for_month(month: Date::MONTHNAMES[date.second], year: date.first)
      revenue = revenue.to_f
      payout = Onboarding.disqo_completes_payout_for_month(month: Date::MONTHNAMES[date.second], year: date.first)
      payout = payout.to_f
      profit = revenue - payout
      [date, completes, revenue, payout, profit]
    end
  end
end
