# frozen_string_literal: true

# 1 argument: # 1 argument: number_of_weeks
# Usage: rails runner lib/scripts/count_clean_id_errors.rb 7

number_of_weeks = ARGV[0].to_i

puts 'ID,ending,total records,error count,error percentage'

ProjectWeek.most_recent(number_of_weeks).each do |week|
  output = "#{week.code},#{week.ending.to_date}"

  output += ",#{week.started_count}"
  output += ",#{week.clean_id_errors.count}"
  output += ",#{week.clean_id_errors.count.to_f / week.started_count}"

  puts output
end
