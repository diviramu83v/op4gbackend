# frozen_string_literal: true

# This job blocks IPs that receive 10 or more InvalidAuthenticityToken errors within the last 30 days
class BlockInvalidAuthenticityTokenIpJob < ApplicationJob
  queue_as :default

  def perform(ip)
    ip.auto_block(reason: 'Invalid authenticity token') if event_count(ip) >= 10
  end

  def event_count(ip)
    ip.events.where(message: 'InvalidAuthenticityToken').where('created_at >= ?', 30.days.ago).count
  end
end
