# frozen_string_literal: true

# 1 argument: end_date (2021-08-01)

# Usage: rails runner lib/scripts/reports/block_reasons.rb 2021-08-01 > ~/Downloads/block_reasons_report.csv

number_of_weeks = 8 # this param is editable for reports

end_time = ARGV[0].to_s
end_time = end_time.to_datetime.utc
start_time = (end_time - number_of_weeks.weeks).beginning_of_day

all_traffic_count = Onboarding.where(created_at: start_time..end_time).count
blocked_traffic = Onboarding.blocked.where(created_at: start_time..end_time)

puts 'Reason blocked, Count, % of traffic'

count_hash = Hash.new(0)

blocked_traffic.find_each do |onboarding|
  next if onboarding.error_message.blank?

  count_hash[onboarding.error_message] += 1
end

count_hash = count_hash.sort_by { |_k, v| -v }.to_h

count_hash.each do |key, value|
  percentage = value / all_traffic_count.to_f

  row = [
    key,
    value,
    percentage
  ]

  puts row.join(',')
end
