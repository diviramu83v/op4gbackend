# frozen_string_literal: true

# Blocks an ip address
class BlockIpAddressJob < ApplicationJob
  queue_as :default

  def perform(ip_address, reason)
    ip = IpAddress.find_by(address: ip_address)
    ip&.auto_block(reason: reason)
  end
end
