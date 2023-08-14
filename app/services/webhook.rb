# frozen_string_literal: true

class FixieError < StandardError; end

# a service for making webhook calls
class Webhook
  def initialize(onboarding:)
    @onboarding = onboarding
  end

  def call_vendor_webhook
    VendorNotificationJob.perform_later(@onboarding) if webhook_ready?
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def notify_vendor_via_webhook
    if webhook_ready?
      send_webhook
      Rails.logger.info "Posted to vendor webhook. UID: #{@onboarding.uid}, Encoded UID: #{@onboarding.token}, URL: #{webhook_full_url}"
      true
    else
      message = "Webhook called, but not ready. UID: #{@onboarding.uid}, Encoded UID: #{@onboarding.token}"
      Rails.logger.error message
      false
    end
  rescue FixieError
    Rails.logger.error "Fixie API failure. UID: #{@onboarding.uid}, Encoded UID: #{@onboarding.token}, URL: #{webhook_full_url}"
    false
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def webhook_full_url
    return unless @onboarding.onramp.webhook_allowed?
    return if webhook_base_url.blank?

    webhook_base_url + webhook_id
  end

  private

  def send_webhook
    url = webhook_full_url
    method = @onboarding.vendor.try(:webhook_method) || 'post'
    Fixie.public_send(method, url: url)
  end

  def webhook_base_url
    return if @onboarding.survey_response_url.blank?

    case @onboarding.survey_response_url.slug
    when 'complete'
      complete_webhook_base_url
    when 'terminate', 'quotafull'
      secondary_webhook_base_url
    end
  end

  def complete_webhook_base_url
    return unless @onboarding.onramp.webhook_allowed?

    @onboarding.vendor.complete_webhook # Vendor or API onramp.
  end

  def secondary_webhook_base_url
    return unless @onboarding.onramp.webhook_allowed?

    @onboarding.vendor.secondary_webhook # Vendor or API onramp.
  end

  def webhook_id
    @onboarding.uid
  end

  def webhook_ready?
    return false unless @onboarding.onramp.webhook_allowed?
    return false if webhook_full_url.blank?

    true
  end
end
