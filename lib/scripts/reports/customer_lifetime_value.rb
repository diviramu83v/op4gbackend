# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/customer_lifetime_value.rb > ~/Downloads/customer_lifetime_value_report.csv

include ApplicationHelper

start_time = Time.now.utc

start_date = 'Jan 1, 2020'
end_date = 'Dec 31, 2020'
one_year = 1.year.to_i

active_panelists = Panelist.active
deactivated_panelists = Panelist.deactivated.where.not(deactivated_at: nil)
suspended_panelists = Panelist.suspended.where.not(suspended_at: nil)
deleted_panelists = Panelist.deleted.where.not(deleted_at: nil)
total_panelists = active_panelists.count + deactivated_panelists.count + suspended_panelists.count + deleted_panelists.count

active_years = active_panelists.map { |panelist| (Time.now.utc - panelist.created_at) / one_year }.sum
deactivated_years = deactivated_panelists.map { |panelist| (panelist.deactivated_at - panelist.created_at) / one_year }.sum
suspended_years = suspended_panelists.map { |panelist| (panelist.suspended_at - panelist.created_at) / one_year }.sum
deleted_years = deleted_panelists.map { |panelist| (panelist.deleted_at - panelist.created_at) / one_year }.sum
total_years = active_years + deactivated_years + suspended_years + deleted_years

surveys = Survey.finished.where('surveys.created_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
surveys_revenue = surveys.map { |survey| survey.cpi.to_f * survey.onboardings.complete.accepted.count }.sum
surveys_taken = surveys.map { |survey| survey.onboardings.complete.accepted.count }.sum
unique_survey_takers = surveys.map { |survey| survey.onboardings.complete.where.not(panelist: nil).pluck(:panelist_id).uniq.count }.sum

average_revenue_per_survey = surveys_revenue / surveys_taken
average_survey_frequency = surveys_taken.to_f / unique_survey_takers
average_panelist_lifespan = total_years / total_panelists
customer_lifetime_value = average_revenue_per_survey * average_survey_frequency * average_panelist_lifespan

puts "\"Customer Lifetime Value Report: #{start_date.to_date.strftime('%B %d, %Y')} to #{end_date.to_date.strftime('%B %d, %Y')}\""
puts '(CLV = Avg Revenue Per Survey * Avg Survey Frequency * Avg Panelist Lifespan)'
puts "Completed in: #{(Time.now.utc - start_time).to_i} seconds"
puts
puts "\"Avg Revenue Per Survey: #{format_currency(average_revenue_per_survey)}\""
puts "\"Avg Survey Frequency: #{format_number(average_survey_frequency.round(2))}\""
puts "\"Avg Panelist Lifespan: #{format_number(average_panelist_lifespan.round(2))} yrs\""
puts "\"Customer Lifetime Value: #{format_currency(customer_lifetime_value)}\""
