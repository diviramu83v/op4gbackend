# frozen_string_literal: true

# Schlesinger sends parameters that need to be hashed and appended as an auth parameter
class SchlesingerUrlGenerator
  def initialize(onboarding:)
    @onboarding = onboarding

    raise 'onboarding parameter must not be nil' if @onboarding.nil?
  end

  def redirect_url
    "#{base_url}?RS=#{response_status}&RID=#{@onboarding.api_params['pid']}&hash=#{hash}"
  end

  private

  def url_to_be_hashed
    "#{base_url}?RS=#{response_status}&RID=#{@onboarding.api_params['pid']}&"
  end

  def hash
    hash = Base64.encode64(OpenSSL::HMAC.digest('sha1', Settings.schlesinger_hash_key, url_to_be_hashed))
    hash = hash.gsub('+', '-').gsub('/', '_').gsub('=', '')
    hash.strip
  end

  def base_url
    Settings.schlesinger_redirect_url
  end

  def response_status
    return 4 if @onboarding.response&.slug.blank?

    {
      complete: 1,
      quotafull: 2,
      terminate: 3
    }[@onboarding.response.slug&.to_sym]
  end
end
