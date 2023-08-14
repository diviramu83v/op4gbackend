# frozen_string_literal: true

# 1 argument: end date, report will generate data for the 8 weeks preceeding this date
# Usage: rails runner lib/scripts/reports/block_rate_by_source.rb 2021-08-01
# Usage: rails runner lib/scripts/reports/block_rate_by_source.rb 2021-08-01 > ~/Downloads/block_rate_by_source.csv

# This report requires more memory than what is available by default. When running the report on production, you should upgrade the dyno size to performance-l.
# heroku run rails runner lib/scripts/reports/block_rate_by_source.rb 2021-08-01 > ~/Downloads/block_rate_by_source.csv --size=performance-l -r production

# Monthly report: put results into new tab in this Google spreadsheet:
# https://docs.google.com/spreadsheets/d/1AFypOzEECQeroNKua4DqIC2BdT7KaNeieSYsbjGn-2s/edit?usp=sharing

def build_hash(onboardings)
  results = {}

  onboardings.find_each do |onboarding|
    if results[combined_source_name(onboarding)].nil?
      results[combined_source_name(onboarding)] = 1
    else
      results[combined_source_name(onboarding)] += 1
    end
  end

  results
end

def combined_source_name(onboarding)
  return 'Disqo' if onboarding.source_name&.include?('Disqo')
  return 'Cint' if onboarding.source_name&.include?('Cint')

  onboarding.source_name
end

def onboardings_from_time_period(start_time, end_time)
  Onboarding.where(created_at: start_time..end_time).includes(:panel, :batch_vendor, :api_vendor)
end

def blocked_onboardings_from_time_period(start_time, end_time)
  Onboarding.blocked.where(created_at: start_time..end_time).includes(:panel, :batch_vendor, :api_vendor)
end

number_of_weeks = 8 # this param is editable for reports

end_time = ARGV[0].to_s
end_time = end_time.to_datetime.utc
start_time = (end_time - 8.weeks).beginning_of_day

previous_start_time = start_time - number_of_weeks.weeks
previous_end_time = start_time

all_records = onboardings_from_time_period(start_time, end_time)
all_previous_records = onboardings_from_time_period(previous_start_time, previous_end_time)
blocks = blocked_onboardings_from_time_period(start_time, end_time)
previous_blocks = blocked_onboardings_from_time_period(previous_start_time, previous_end_time)

grouped_counts = build_hash(all_records)
grouped_previous_counts = build_hash(all_previous_records)
grouped_blocks = build_hash(blocks)
grouped_previous_blocks = build_hash(previous_blocks)

puts 'Source,Count: last 8 weeks,Block count: last 8 weeks,Count: previous 8 weeks,Block count: previous 8 weeks,% of total,% change (% of total)'

grouped_blocks.each do |source, block_count|
  count = grouped_counts[source].to_f
  previous_count = grouped_previous_counts[source].to_f
  previous_block_count = grouped_previous_blocks[source].to_f

  puts "\"#{source}\",\"#{count}\",\"#{block_count}\",\"#{previous_count}\",\"#{previous_block_count}\""
end
