# frozen_string_literal: true

# This job runs regularly to cut off traffic from bad IP addresses.
class AddSuspiciousIpsToDenylistJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform
    IpAddress.block_suspicious_ips
  end
end
