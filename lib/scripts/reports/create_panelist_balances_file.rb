# frozen_string_literal: true

# 1 argument: panelist_status
# Usage: rails runner lib/scripts/reports/create_panelist_balances_file.rb active > ~/Downloads/Panelist_Current_Balances-Dec_2022_active.csv

# We have to run this report in pieces because otherwise it will time out. Run with the following panelist_status arguments:

# signing_up
# active
# suspended
# deleted
# deactivated
# deactivated_signup

# heroku run rails runner lib/scripts/reports/create_panelist_balances_file.rb active > ~/Downloads/Panelist_Current_Balances-Dec_2022.csv --size=performance-l -r production

panelists = []
total_balance = 0
last_period = Time.now.utc.last_month.strftime('%Y-%m')

panelist_status = ARGV[0]

Panelist.find_each do |panelist|
  next unless panelist.status == panelist_status
  next if panelist.balance.zero?

  total_balance += panelist.balance
  panelists << panelist
end

puts "Total Balance Owed: #{total_balance}"

puts 'panelist status, id, name, current balance, email, postal code, last activity, complete surveys last month, total earned last month'

panelists.each do |panelist|
  row = [
    panelist.status,
    panelist.id,
    panelist.name.gsub(',', ''),
    panelist.balance,
    panelist.email,
    panelist.postal_code&.gsub(',', ''),
    panelist.last_activity_at&.strftime('%m/%-d/%Y'),
    panelist.invitations.survey_finished_in_past_month.count,
    panelist.earnings.active.where(period: last_period).sum(&:panelist_amount)
  ]
  puts row.join(',')
end
