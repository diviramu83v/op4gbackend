# frozen_string_literal: true

# 1 argument: # 1 argument: number_of_weeks
# Usage: rails runner lib/scripts/compile_onboarding_blocked_reasons.rb 1

start_script = Time.zone.now
number_of_weeks = ARGV[0].to_i
start_time = number_of_weeks.weeks.ago.beginning_of_week
end_time = (start_time + 7.weeks).end_of_week

puts start_time
puts end_time

onboardings = Onboarding.blocked.where(created_at: start_time..end_time)

puts "#{onboardings.count} records retrieved"
puts
puts 'Failed reason, Count'
count_hash = Hash.new(0)

onboardings.find_each do |onboarding|
  next if onboarding.error_message.blank?

  count_hash[onboarding.error_message] += 1
end

count_hash = count_hash.sort_by { |_k, v| -v }.to_h

count_hash.each do |key, value|
  if key.blank?
    printf "%-5<value>s %<reason>s\n", value: value, reason: 'No reason found'
  else
    printf "%-5<value>s %<key>s\n", value: value, key: key
  end
end

end_script = Time.zone.now
puts "Run time: #{(end_script - start_script).to_i} seconds"
