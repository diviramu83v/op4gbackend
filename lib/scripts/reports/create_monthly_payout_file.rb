# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/create_monthly_payout_file.rb > ~/Downloads/Earnings_Report-Eligible_Sept_2022.csv

payout_panelists = []

# Generally want to exclude the current period's worth of earnings.
period_array = [PeriodCalculator.current_period]

Panelist.active.find_each do |panelist|
  balance = panelist.balance_excluding_period(period_array)
  payout_panelists << panelist if panelist.suspend_and_pay_status == true || balance >= Payment::MINIMUM_PAYOUT_IN_DOLLARS
end

payout_panelists.sort! { |x, y| y.balance_excluding_period(period_array) <=> x.balance_excluding_period(period_array) }

puts 'id,name,email,balance,CleanID score (<25),CleanID unique (true),verified?, score percentile'

payout_panelists.each do |panelist|
  next if panelist.clean_id_data.blank?

  clean_id_score = panelist.clean_id_data.dig('forensic', 'marker', 'score')
  clean_id_unique = panelist.clean_id_data.dig('forensic', 'unique', 'isEventUnique')

  row = [
    panelist.id,
    panelist.name,
    panelist.email,
    panelist.balance_excluding_period(period_array),
    clean_id_score,
    clean_id_unique,
    panelist.verified?,
    panelist.score_percentile
  ]

  puts row.join(',')
end
