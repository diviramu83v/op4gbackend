# frozen_string_literal: true

# Usage: rails runner lib/scripts/block_ip_addresses_of_fraudulent_ids.rb
start_script = Time.zone.now

onboardings = Onboarding.fraudulent

onboardings.find_each do |onboarding|
  next if onboarding.ip_address.blank?

  onboarding.ip_address.manually_block(reason: 'fraudulent uids')
end

end_script = Time.zone.now
puts "Run time: #{(end_script - start_script).to_i} seconds"
