# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/survey_frequency_rate.rb > ~/Downloads/survey_frequency_rate_report.csv

include ApplicationHelper

start_date = 'Jan 1, 2020'
end_date = 'Dec 31, 2020'

start_time = Time.now.utc

surveys = Survey.finished.where('surveys.created_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)

total_surveys_taken = surveys.map { |survey| survey.onboardings.complete.accepted.count }.sum

total_unique_survey_takers = surveys.map { |survey| survey.onboardings.complete.where.not(panelist: nil).pluck(:panelist_id).uniq.count }.sum

total_average_survey_frequency = total_surveys_taken.to_f / total_unique_survey_takers

puts "\"Survey Frequency Rate Report: #{start_date.to_date.strftime('%B %d, %Y')} to #{end_date.to_date.strftime('%B %d, %Y')}\""
puts "\"Total Surveys Taken: #{format_number(total_surveys_taken)}\""
puts "\"Total Unique Survey Takers: #{format_number(total_unique_survey_takers)}\""
puts "\"Total Avg Survey Frequency: #{total_average_survey_frequency.to_f.round(2)}\""
puts "Completed in: #{(Time.now.utc - start_time).to_i} seconds"
puts
puts 'Project Name, Survey Name, Times Taken, Unique Survery Takers, Avg Survey Frequency'

surveys.by_first_created.each do |survey|
  times_taken = survey.onboardings.complete.accepted.count
  unique_survey_takers = survey.onboardings.complete.where.not(panelist: nil).pluck(:panelist_id).uniq.count
  average_survey_frequency = times_taken.to_f / unique_survey_takers

  puts "\"#{survey.project.name}\",\"#{survey.name}\",\"#{format_number(times_taken)}\",\"#{format_number(unique_survey_takers)}\",\"#{average_survey_frequency.to_s.to_f.round(2)}\""
end
