# frozen_string_literal: true

# 1 argument: email
# Usage: rails runner lib/scripts/print_recent_traffic_for_panelist.rb vicki-coffey@cox.net

require_relative './concerns/onboarding_traffic_patterns'

ApplicationRecord::Onboarding.prepend(OnboardingTrafficPatterns)

email = ARGV[0]
panelist = Panelist.find_by(email: email)
return if panelist.nil?

puts "Panelist: #{panelist.name} / #{panelist.email}"

onboardings = panelist.onboardings.order(:created_at)

onboardings.find_each(&:print_traffic_data)
