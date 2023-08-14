# frozen_string_literal: true

# this provides methods for the
# panelist net profit reporting stats
module PanelistNetProfit
  def calculate_net_profit
    format('%.2f',
           Onboarding.complete
                     .joins(:earning, :panelist, :survey)
                     .where(panelist: panelists)
                     .sum('surveys.cpi_cents - earnings.total_amount_cents').to_f / 100)
  end

  def calculate_total_cpi
    format('%.2f',
           Onboarding.complete
                     .joins(:earning, :panelist, :survey)
                     .where(panelist: panelists)
                     .sum('surveys.cpi_cents').to_f / 100)
  end

  def calculate_total_earnings
    format('%.2f',
           Onboarding.complete
                     .joins(:earning, :panelist, :survey)
                     .where(panelist: panelists)
                     .sum('earnings.total_amount_cents').to_f / 100)
  end
end
