# frozen_string_literal: true

# 1 argument: api_vendor_id
# usage: rails runner lib/scripts/remove_onramps_for_api_vendor.rb 231

api_vendor_id = ARGV[0].to_i

vendor = Vendor.find_by(id: api_vendor_id)

if vendor.blank?
  puts 'No vendor found.'
  return
end

Onramp.where(api_vendor_id: api_vendor_id).each(&:delete)
