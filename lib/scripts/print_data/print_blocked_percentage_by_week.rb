# frozen_string_literal: true

# 1 argument: # 1 argument: number_of_weeks
# Usage: rails runner lib/scripts/print_blocked_percentage_by_week.rb 7

number_of_weeks = ARGV[0].to_i

puts 'ID,ending,total records,blocked %'

ProjectWeek.most_recent(number_of_weeks).each do |week|
  output = "#{week.code},#{week.ending.to_date}"
  output += ",#{week.started_count}"
  output += ",#{week.blocked_count.to_f / week.started_count}"

  puts output
end
