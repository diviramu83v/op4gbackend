# frozen_string_literal: true

# Notifies vendors (HasOffers) of completion response.
class VendorNotificationJob < ApplicationJob
  queue_as :default

  def perform(onboarding)
    return if onboarding.webhook_notification_sent? # Prevent re-run.
    raise "onboarding #{onboarding.id}: call to vendor webhook was unsuccessful" unless Webhook.new(onboarding: onboarding).notify_vendor_via_webhook

    onboarding.mark_webhook_sent
  end
end
