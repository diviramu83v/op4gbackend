# frozen_string_literal: true

# 1 argument: number_of_days
# Usage: rails runner lib/scripts/print_odd_traffic_check_data_for_recent_timeframe.rb 7

require_relative './concerns/onboarding_traffic_patterns'

ApplicationRecord::Onboarding.prepend(OnboardingTrafficPatterns)

number_of_days = ARGV[0]
timestamp = Time.now.utc - number_of_days.to_i.days
puts "#{timestamp} - #{Time.now.utc}"

onboardings = Onboarding.where('created_at >= ?', timestamp)

onboardings.initialized.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_initialized_steps?

  onboarding.print_traffic_data
end

onboardings.blocked.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?

  # next if onboarding.expected_blocked_steps?

  onboarding.print_traffic_data
end

onboardings.screened.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_screened_steps?

  onboarding.print_traffic_data
end

onboardings.survey_started.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_survey_started_steps?

  onboarding.print_traffic_data
end

onboardings.survey_finished.find_each do |onboarding|
  next if onboarding.traffic_steps.count.zero?
  next if onboarding.expected_survey_finished_steps?

  onboarding.print_traffic_data
end
