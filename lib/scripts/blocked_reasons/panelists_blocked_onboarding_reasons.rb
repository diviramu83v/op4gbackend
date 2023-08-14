# frozen_string_literal: true

# 1 argument: # 1 argument: panelist email
# Usage: rails runner lib/scripts/panelists_blocked_onboarding_reasons.rb alinecossta@hotmail.com

start_script = Time.zone.now
panelist_email = ARGV[0]
panelist = Panelist.find_by(email: panelist_email)

# rubocop:disable Lint/TopLevelReturnWithArgument
return puts 'panelist not found' if panelist.blank?

# rubocop:enable Lint/TopLevelReturnWithArgument

puts "panelist: #{panelist.name}"
puts "email: #{panelist.email}"
puts

recent_completes = panelist.onboardings.complete.where('onboardings.created_at >= ?', 90.days.ago)

recent_count = recent_completes.count
fraudulent_count = recent_completes.fraudulent.count
rejected_count = recent_completes.rejected.count
accepted_count = recent_completes.accepted.count
pending_count = recent_completes.where(client_status: nil).count

puts "LAST 90 days: #{recent_count} completes"
puts "fraudulent: #{fraudulent_count} (#{(fraudulent_count.to_f / recent_count * 100).round(2)}%)"
puts "rejected: #{rejected_count} (#{(rejected_count.to_f / recent_count * 100).round(2)}%)"
puts "accepted: #{accepted_count} (#{(accepted_count.to_f / recent_count * 100).round(2)}%)"
puts "pending: #{pending_count} (#{(pending_count.to_f / recent_count * 100).round(2)}%)"
puts

blocked_onboardings = panelist.onboardings.blocked.most_recent_first

puts 'BLOCKED:'
puts "#{blocked_onboardings.count} records retrieved"
count_hash = Hash.new(0)
printf "\n%-15<id>s %<reason>s\n", id: 'Onboarding ID', reason: 'Failed reason'
blocked_onboardings.each do |onboarding|
  next if onboarding.traffic_steps.blank?

  analyzer = TrafficAnalyzer.new(onboarding: onboarding)
  printf "%-15<id>s %<reason>s\n", id: onboarding.id, reason: analyzer.failed_reason || onboarding.error_message
end

blocked_onboardings.find_each do |onboarding|
  next if onboarding.traffic_steps.blank?

  analyzer = TrafficAnalyzer.new(onboarding: onboarding)
  count_hash[analyzer.failed_reason] += 1
end

count_hash = count_hash.sort_by { |_k, v| -v }.to_h

printf "\n%-15<count>s %<reason>s\n", count: 'Count', reason: 'Reason'
count_hash.each do |key, value|
  if key.blank?
    printf "%-15<value>s %<reason>s\n", value: value, reason: 'No reason found'
  else
    printf "%-15<value>s %<key>s\n", value: value, key: key
  end
end

end_script = Time.zone.now
puts "Run time: #{(end_script - start_script).to_i} seconds"
