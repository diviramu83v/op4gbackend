# frozen_string_literal: true

class BackfillOldTrafficChecksIpAddresses < ActiveRecord::Migration[5.2]
  def change
    TrafficCheck.find_each do |traffic_check|
      ip = IpAddress.find_by(address: traffic_check.ip_address)
      next if ip.blank?

      traffic_check.update(ip_address_id: ip.id)
    end
  end
end
