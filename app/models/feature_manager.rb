# frozen_string_literal: true

# Handles feature flags so we can turn features on and off if necessary.
class FeatureManager
  def self.ip_auto_blocking?
    ENV.fetch('FEATURE_IP_AUTO_BLOCKING', 'off') == 'on'
  end

  def self.send_real_mimi_emails?
    ENV.fetch('FEATURE_MIMI_API_CALLS', 'off') == 'on'
  end

  def self.panelist_facebook_auth?
    ENV.fetch('FEATURE_PANELIST_FACEBOOK_AUTH', 'off') == 'on'
  end

  def self.panelist_paypal_verification?
    ENV.fetch('FEATURE_PAYPAL_VERIFICATION', 'off') == 'on'
  end
end
