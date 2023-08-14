# frozen_string_literal: true

# 1 argument: payout_period
# Usage: rails runner lib/scripts/reports/create_annual_payout_file.rb 2022 > ~/Downloads/Annual_Earnings_Report-2022.csv
# This report allows us to see totals paid for a specific year: Total payouts, payouts to panelists, and payouts to nonprofits

payout_period = ARGV[0].to_s

annual_total = 0
panelist_payouts = 0
nonprofit_payouts = 0

Earning.find_each do |earning|
  next unless earning.period_year == payout_period

  annual_total += earning.total_amount
  panelist_payouts += earning.panelist_amount
  nonprofit_payouts += earning.nonprofit_amount
end

puts "Year: #{payout_period}"
puts "Payout total: $#{annual_total}"
puts "Panelist payout total: $#{panelist_payouts}"
puts "Nonprofit payout total: $#{nonprofit_payouts}"
