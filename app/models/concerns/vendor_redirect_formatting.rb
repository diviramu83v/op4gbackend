# frozen_string_literal: true

# Extracts URL formatting requirements unique to vendor redirects.
module VendorRedirectFormatting
  include ActiveSupport::Concern

  private

  def urls_formatted_correctly
    errors.add(:complete_url, 'must start with http:// or https://') unless url_starts_correctly(complete_url)
    errors.add(:terminate_url, 'must start with http:// or https://') unless url_starts_correctly(terminate_url)
    errors.add(:overquota_url, 'must start with http:// or https://') unless url_starts_correctly(overquota_url)
    errors.add(:security_url, 'must start with http:// or https://') unless url_starts_correctly(security_url)
  end

  def url_starts_correctly(url)
    return true if url.blank? # Don't check empty/missing URLs.

    url[0, 7] == 'http://' || url[0, 8] == 'https://'
  end
end
