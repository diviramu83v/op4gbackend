# frozen_string_literal: true

# Usage: rails runner lib/scripts/print_recent_clean_id_errors.rb

week = ProjectWeek.new(starting: 3.days.ago, ending: Time.now.utc)

puts 'timestamp,channel,reqId,eventid,error message'

week.clean_id_errors.each do |error|
  output = ''

  output += "#{error.created_at},"
  output += "#{error.onboarding.source_name},"
  output += "#{error.onboarding.onboarding_token},"
  output += "#{error.traffic_step.security_service_survey_id},"
  output += error.data_collected.to_s
                 .gsub('{"error":{"message":"', '')
                 .gsub('{"error"=>{"message"=>"', '')
                 .gsub('"}}', '')

  puts output
end
