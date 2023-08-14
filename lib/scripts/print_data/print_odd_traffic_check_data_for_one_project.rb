# frozen_string_literal: true

# 1 argument: project_id
# Usage: rails runner lib/scripts/print_odd_traffic_check_data_for_one_project.rb 17092

require_relative './concerns/onboarding_traffic_patterns'

ApplicationRecord::Onboarding.prepend(OnboardingTrafficPatterns)

project_id = ARGV[0]
project = Project.find(project_id)

puts

id = project.id
status = project.status

puts "#{id}:#{status}"
puts

project.onboardings.initialized.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_initialized_steps?

  onboarding.print_traffic_data
end

project.onboardings.blocked.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_blocked_steps?

  onboarding.print_traffic_data
end

project.onboardings.screened.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_screened_steps?

  onboarding.print_traffic_data
end

project.onboardings.survey_started.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_survey_started_steps?

  onboarding.print_traffic_data
end

project.onboardings.survey_finished.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_survey_finished_steps?

  onboarding.print_traffic_data
end
