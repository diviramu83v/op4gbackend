# frozen_string_literal: true

# 1 argument: # 1 argument: number_of_weeks
# Usage: rails runner lib/scripts/print_blocked_percentage_by_week_and_source.rb 7

number_of_weeks = ARGV[0].to_i

puts 'Source, ID, ending, total records, blocked %'

# start_script = Time.zone.now

Vendor.all.each do |vendor|
  ProjectWeek.most_recent(number_of_weeks, source: vendor).each do |week|
    next if week.started_count.zero?

    puts "Vendor: #{vendor.name},#{week.code},#{week.ending.to_date},#{week.started_count},#{week.blocked_count.to_f / week.started_count}"
  end
end

Panel.all.each do |panel|
  ProjectWeek.most_recent(number_of_weeks, source: panel).each do |week|
    next if week.started_count.zero?

    puts "Panel: #{panel.name},#{week.code},#{week.ending.to_date},#{week.started_count},#{week.blocked_count.to_f / week.started_count}"
  end
end

# end_script = Time.zone.now

# puts "Run time: #{(end_script - start_script).to_i} seconds"
