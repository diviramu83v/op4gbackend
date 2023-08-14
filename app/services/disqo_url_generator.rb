# frozen_string_literal: true

# Disqo sends parameters that need to be hashed and appended as an auth parameter
class DisqoUrlGenerator
  def initialize(onboarding:)
    @onboarding = onboarding
    @key = Settings.disqo_hash_key
    @analyzer ||= TrafficAnalyzer.new(onboarding: @onboarding)

    raise 'onboarding parameter must not be nil' if @onboarding.nil?
    raise 'DISQO key missing' if @key.nil?
  end

  def redirect_url
    "#{base_url}?#{saved_params}&status=#{status}&auth=#{hashed_parameters}"
  end

  private

  def base_url
    Settings.disqo_redirect_url
  end

  def params_to_be_hashed
    "#{saved_params}&status=#{status}"
  end

  def status
    slug = @onboarding.survey_response_url&.slug

    return '8' if @analyzer.failed_prescreener?
    return '4' if slug.nil? # no response => should be the blocked records

    status = {
      'complete' => '1',
      'quotafull' => '2',
      'terminate' => '3'
    }

    status[slug]
  end

  def hashed_parameters
    hash = Base64.encode64(OpenSSL::HMAC.digest('sha1', @key, CGI.unescape(params_to_be_hashed)))
    hash = hash.gsub('+', '-').gsub('/', '_')
    hash = hash.strip
    hash = hash[0...-1] if hash[-1] == '=' # Remove final equals sign.
    hash
  end

  def saved_params
    return @saved_params if @saved_params.present?

    data = @onboarding.api_params

    # rubocop:disable Layout/LineLength
    @saved_params = "clientId=#{data['clientId']}&projectId=#{data['projectId']}&quotaIds=#{data['quotaIds']}&supplierId=#{data['supplierId']}&tid=#{data['tid']}&pid=#{data['pid']}"
    # rubocop:enable Layout/LineLength
  end
end
