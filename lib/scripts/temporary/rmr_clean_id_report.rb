# frozen_string_literal: true

# Usage: rails runner lib/scripts/temporary/rmr_clean_id_report.rb > ~/Downloads/rmr_clean_id_report.csv

vendor = Vendor.find_by(name: 'RMRR')
blocked_onboardings = vendor.onboardings.blocked.where("error_message LIKE '%CleanID%'")

puts 'traffic ID, RMR ID, Timestamp, Project, CleanID Reason'

blocked_onboardings.each do |onboarding|
  row = [
    onboarding.token,
    onboarding.uid,
    onboarding.failed_onboarding_at,
    onboarding.project.id,
    onboarding.error_message
  ]

  puts row.join(',')
end
