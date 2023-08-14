# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/average_revenue_per_survey.rb > ~/Downloads/survey_revenue_report.csv

include ApplicationHelper

start_time = 'Jan 1, 2020'.to_date.beginning_of_day
end_time = 'Dec 31, 2020'.to_date.end_of_day

puts "Survey Revenue Report: #{start_time.strftime('%B %d, %Y')} to #{end_time.strftime('%B %d, %Y')}"

surveys = Survey.finished.where('surveys.created_at BETWEEN ? AND ?', start_time, end_time).order(:project_id, :created_at)

total_surveys = 0
skipped_surveys = 0
total_completes_predicted = 0
total_completes_tracked = 0
total_completes_accepted = 0
total_revenue_predicted = 0.0
total_revenue_tracked = 0.0
total_revenue_accepted = 0.0

headers = [
  'Project',
  'Product name',
  'Survey',
  'Completes predicted',
  'Completes tracked',
  'Completes accepted',
  'CPI',
  'Revenue predicted',
  'Revenue tracked',
  'Revenue accepted'
]

puts headers.join(',')

# rubocop:disable Metrics/BlockLength
surveys.by_first_created.each do |survey|
  if survey.onboardings.count.zero? # || survey.target.nil?
    skipped_surveys += 1
    next
  end

  completes_predicted = survey.target
  completes_tracked = survey.adjusted_complete_count
  completes_accepted = survey.onboardings.complete.accepted.count
  # completes_best = completes_accepted.positive? ? completes_accepted : completes_tracked

  cpi = survey.cpi.to_f
  revenue_predicted = cpi * completes_predicted
  revenue_tracked = cpi * completes_tracked
  revenue_accepted = cpi * completes_accepted
  # revenue_best = revenue_accepted.positive? ? revenue_accepted : revenue_tracked

  columns = [
    survey.project.name,
    survey.project.product.name,
    survey.name,
    format_number(completes_predicted),
    format_number(completes_tracked),
    format_number(completes_accepted),
    format_currency(cpi),
    format_currency(revenue_predicted),
    format_currency(revenue_tracked),
    format_currency(revenue_accepted)
  ]

  total_surveys += 1
  total_completes_predicted += completes_predicted
  total_completes_tracked += completes_tracked
  total_completes_accepted += completes_accepted
  total_revenue_predicted += revenue_predicted
  total_revenue_tracked += revenue_tracked
  total_revenue_accepted += revenue_accepted

  puts columns.map { |column| "\"#{column}\"" }.join(',')
end
# rubocop:enable Metrics/BlockLength

puts

puts "Skipped surveys: #{format_number(skipped_surveys)}" if skipped_surveys.positive?
puts "Total surveys: #{format_number(total_surveys)}"
puts
puts "Total completes predicted: #{format_number(total_completes_predicted)}"
puts "Total completes tracked: #{format_number(total_completes_tracked)}"
puts "Total completes accepted: #{format_number(total_completes_accepted)}"
puts
puts "Total revenue predicted: #{format_currency(total_revenue_predicted)}"
puts "Total revenue tracked: #{format_currency(total_revenue_tracked)}"
puts "Total revenue accepted: #{format_currency(total_revenue_accepted)}"
puts
puts "Revenue predicted: #{format_currency(total_revenue_predicted / total_surveys)} per survey / #{format_currency(total_revenue_predicted / total_completes_predicted)} per complete"
puts "Revenue tracked: #{format_currency(total_revenue_tracked / total_surveys)} per survey / #{format_currency(total_revenue_tracked / total_completes_tracked)} per complete"
puts "Revenue accepted: #{format_currency(total_revenue_accepted / total_surveys)} per survey / #{format_currency(total_revenue_accepted / total_completes_accepted)} per complete"
