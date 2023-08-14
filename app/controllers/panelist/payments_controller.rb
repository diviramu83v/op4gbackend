# frozen_string_literal: true

class Panelist::PaymentsController < Panelist::BaseController
  def show
    @years = current_panelist.active_financial_period_years
    @details_present = @years.any? || current_panelist.legacy_earnings.positive?
  end
end
