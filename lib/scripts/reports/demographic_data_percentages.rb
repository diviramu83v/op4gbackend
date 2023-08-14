# frozen_string_literal: true

# Usage: rails runner lib/scripts/reports/demographic_data_percentages.rb > ~/Downloads/demo_data.csv

panel = Panel.find_by(name: 'Op4G')
panel.demo_questions.each do |demo_question|
  puts demo_question.body

  options = []
  demo_question.demo_options.pluck(:label).each do |option|
    options << option
  end

  puts options.join(',')

  panelists_that_have_answered = demo_question.demo_options.inject(0) { |sum, option| sum + option.panelists.count }
  bill = demo_question.demo_options.map do |demo_option|
    "#{((demo_option.panelists.count.to_f / panelists_that_have_answered) * 100).round(2)} %"
  end

  puts bill.join(',')
end
