# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/customer_value.rb > ~/Downloads/customer_value_report.csv

include ApplicationHelper

start_date = 'Jan 1, 2020'
end_date = 'Dec 31, 2020'

start_time = Time.now.utc

surveys = Survey.finished.where('surveys.created_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)

total_surveys_taken = surveys.map { |survey| survey.onboardings.complete.accepted.count }.sum

total_surveys_revenue = surveys.map { |survey| survey.cpi.to_f * survey.onboardings.complete.accepted.count }.sum

average_revenue_per_survey = total_surveys_revenue / total_surveys_taken

total_unique_survey_takers = surveys.map { |survey| survey.onboardings.complete.where.not(panelist: nil).pluck(:panelist_id).uniq.count }.sum

total_average_survey_frequency = total_surveys_taken.to_f / total_unique_survey_takers

total_customer_value = average_revenue_per_survey.to_f * total_average_survey_frequency

total_panelists = Panelist.active.where('created_at < ?', 'January 1, 2021'.to_date).count

total_invitations = ProjectInvitation.where('created_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day).count

average_invites = total_invitations / total_panelists

puts "\"Customer Value Report: #{start_date.to_date.strftime('%B %d, %Y')} to #{end_date.to_date.strftime('%B %d, %Y')}\""
puts "\"Total Surveys Taken: #{format_number(total_surveys_taken)}\""
puts "Average Revenue Per Survey: #{format_currency(average_revenue_per_survey)}"
puts "Average Survey Frequency: #{total_average_survey_frequency.round(4)}"
puts "Customer Value: #{format_currency(total_customer_value)}"
puts "\"Avg # of Survey Invitations Per Panelist: #{format_number(average_invites)}\""
puts "Completed in: #{(Time.now.utc - start_time).to_i} seconds"
puts
puts 'Project Name, Survey Name, Avg Revenue Per Survey, Avg Survey Frequency, Customer Value'

surveys.by_first_created.each do |survey|
  revenue = survey.cpi.to_f * survey.onboardings.complete.accepted.count
  times_taken = survey.onboardings.complete.accepted.count
  average_revenue_per_survey = revenue / times_taken
  unique_survey_takers = survey.onboardings.complete.where.not(panelist: nil).pluck(:panelist_id).uniq.count
  average_survey_frequency = times_taken.to_f / unique_survey_takers
  customer_value = average_revenue_per_survey.to_f * average_survey_frequency

  puts "\"#{survey.project.name}\",\"#{survey.name}\",\"#{format_currency(average_revenue_per_survey.to_s.to_f)}\",\"#{average_survey_frequency.to_s.to_f.round(4)}\",\"#{format_currency(customer_value.to_s.to_f)}\""
end
