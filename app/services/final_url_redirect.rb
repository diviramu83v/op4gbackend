# frozen_string_literal: true

# Finds the redirect url for onboardings
class FinalUrlRedirect
  include Rails.application.routes.url_helpers

  def initialize(onboarding:)
    @onboarding = onboarding
  end

  def final_url
    disqo_redirect_url || cint_redirect_url || schlesinger_redirect_url || vendor_redirect_url || fallback_redirect_url
  end

  # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def failed_traffic_steps_url
    return disqo_redirect_url if @onboarding.onramp.disqo?
    return cint_redirect_url if @onboarding.onramp.cint?
    return schlesinger_redirect_url if @onboarding.onramp.schlesinger?
    return survey_return_key_errors_url if key_analyzer.bad_key?

    url = @onboarding.vendor_batch&.security_url ||
          @onboarding.vendor&.security_url ||
          @onboarding.vendor_batch&.terminate_url ||
          @onboarding.vendor&.terminate_url
    return UrlHasher.new(url: url + @onboarding.uid, vendor: @onboarding.vendor).url_hashed_if_needed if url.present?

    survey_security_errors_url(onboarding_id: @onboarding)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  private

  def sid
    @sid ||= @onboarding.project.id
  end

  def key_analyzer
    @key_analyzer ||= ReturnKeyAnalyzer.new(onboarding: @onboarding)
  end

  def fallback_redirect_url
    response = @onboarding.survey_response_url

    case response&.slug
    when 'complete' then complete_url_with_sid
    when 'terminate' then terminate_url_with_sid
    when 'quotafull' then quotafull_url_with_sid
    else
      survey_security_errors_url(onboarding_id: @onboarding.id)
    end
  end

  def disqo_redirect_url
    return unless @onboarding.onramp.disqo?

    url = DisqoUrlGenerator.new(onboarding: @onboarding).redirect_url
    Rails.logger.info("Disqo redirect url: #{url}")
    url
  end

  def cint_redirect_url
    return unless @onboarding.onramp.cint?

    "#{Settings.cint_redirect_url}/#{@onboarding.uid}"
  end

  def schlesinger_redirect_url
    return unless @onboarding.onramp.schlesinger?

    url = SchlesingerUrlGenerator.new(onboarding: @onboarding).redirect_url
    Rails.logger.info("Schlesinger redirect url: #{url}")
    url
  end

  def vendor_redirect_url
    response = @onboarding.response
    return if response.blank?

    return if @onboarding.vendor.blank?

    base_url = vendor_redirect_base_url(response)
    return if base_url.blank?

    combined_url = base_url + @onboarding.uid
    UrlHasher.new(url: combined_url, vendor: @onboarding.vendor).url_hashed_if_needed
  end

  def vendor_redirect_base_url(response)
    return @onboarding.vendor.redirect_url(response) if @onboarding.api?

    @onboarding.vendor_batch.base_redirect_url(response)
  end

  def complete_url_with_sid
    survey_complete_url(token: @onboarding.response_token, sid: sid)
  end

  def terminate_url_with_sid
    survey_screened_url(token: @onboarding.response_token, sid: sid)
  end

  def quotafull_url_with_sid
    survey_full_url(token: @onboarding.response_token, sid: sid)
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
