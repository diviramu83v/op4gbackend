# frozen_string_literal: true

# usage: rails runner lib/scripts/ip_addresses_for_fraudulent_completes.rb

onboardings = Onboarding.joins(:onramp).where(onramps: { check_clean_id: true }).complete.fraudulent.where('onboardings.created_at >= ?', 90.days.ago)
ip_addresses = Hash.new(0)

onboardings.find_each do |onboarding|
  ip_addresses[onboarding.ip_address.address] += 1
end

ip_addresses.sort_by(&:last).reverse.each do |key, value|
  puts "IP: #{key} COUNT: #{value}"
end
