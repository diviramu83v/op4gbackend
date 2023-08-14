# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/complete_traffic_by_source.rb <accepted/rejected/fraudulent> <end-date YYYY-MM-DD>

expected_usage = 'rails runner lib/scripts/reports/complete_traffic_by_source.rb <accepted/rejected/fraudulent> <end-date YYYY-MM-DD>'

@report_type = ARGV[0]
if @report_type.nil?
  puts 'No client status provided.'
  puts "Expected usage: #{expected_usage}"
  return
end

end_date = ARGV[1]
if end_date.nil?
  puts 'No end date provided.'
  puts "Expected usage: #{expected_usage}"
  return
end
end_date = Date.strptime(end_date, '%Y-%m-%d')

current_period_ends_at = end_date.end_of_day
current_period_starts_at = (end_date - 8.weeks + 1.day).beginning_of_day
previous_period_ends_at = current_period_starts_at - 1.second
previous_period_starts_at = (current_period_starts_at - 8.weeks).beginning_of_day
puts "#{@report_type.capitalize} completes: #{current_period_starts_at.to_date} => #{current_period_ends_at.to_date}"

# puts previous_period_starts_at
# puts previous_period_ends_at

def onboarding_type
  return Onboarding.complete.rejected if @report_type.downcase == 'rejected'
  return Onboarding.complete.fraudulent if @report_type.downcase == 'fraudulent'

  Onboarding.complete.accepted
end

current_completes = onboarding_type
                    .where('onboardings.created_at >= ?', current_period_starts_at)
                    .where('onboardings.created_at <= ?', current_period_ends_at)
                    .includes(:panel, :batch_vendor, :api_vendor)

previous_completes = onboarding_type
                     .where('onboardings.created_at >= ?', previous_period_starts_at)
                     .where('onboardings.created_at <= ?', previous_period_ends_at)
                     .includes(:panel, :batch_vendor, :api_vendor)

current_completes_total = current_completes.count
previous_completes_total = previous_completes.count

def source_name(complete)
  return 'Disqo' if complete.source_name.include?('Disqo')
  return 'Cint' if complete.source_name.include?('Cint')

  complete.source_name
end

def group_and_count(completes)
  completes.each_with_object(Hash.new(0)) do |complete, hash|
    hash[source_name(complete).to_s] += 1 unless complete.security_status == 'other'
  end
end

current_completes_grouped = group_and_count(current_completes)
previous_completes_grouped = group_and_count(previous_completes)

current_completes_sorted = current_completes_grouped.sort_by do |_source, count|
  count
end.reverse

# puts "Source,Previous count,Previous share,Current count,Current share,Change in share"
puts 'Source,Current count,Current share,Change in share'

def wrap_value(value)
  "\"#{value}\""
end

current_completes_sorted.each do |source, current_completes_count|
  current_completes_share = current_completes_count.to_f / current_completes_total
  previous_completes_count = previous_completes_grouped[source]
  previous_completes_share = previous_completes_count.to_f / previous_completes_total

  puts "#{wrap_value(source)}," \
       "#{current_completes_count}," \
       "#{current_completes_share}," \
       "#{current_completes_share - previous_completes_share}"
end
