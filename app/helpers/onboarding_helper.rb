# frozen_string_literal: true

# View helpers for traffic.
module OnboardingHelper
  def format_onboarding_security(onboarding)
    return if onboarding.nil?

    tag.span(onboarding_security_text(onboarding),
             class: "badge badge-#{onboarding_security_button_class(onboarding)}")
  end

  def format_onboarding_response(onboarding)
    return if onboarding.nil?
    return if onboarding.survey_response_url.nil?

    tag.span(onboarding.survey_response_url.slug,
             class: "badge badge-#{onboarding_response_button_class(onboarding)}")
  end

  def onboarding_security_text(onboarding)
    return 'blocked' if onboarding.blocked?
    return 'pre-screened' if onboarding.screened?

    if onboarding.onboarded?
      return 'bypassed security' if onboarding.bypassed_security?
      return 'n/a' if onboarding.onramp.requires_no_security_checks?

      return 'cleared security'
    end
    'pending/drop out'
  end

  private

  def onboarding_security_button_class(onboarding)
    return 'danger' if onboarding.blocked?
    return 'dark' if onboarding.screened?

    if onboarding.onboarded?
      return 'warning' if onboarding.bypassed_security? && onboarding.category != Onramp.categories[:testing]

      return 'success'
    end
    'light'
  end

  def onboarding_response_button_class(onboarding)
    case onboarding.survey_response_url.try(:slug)
    when 'complete' then 'success'
    when 'quotafull' then 'warning'
    when 'terminate' then 'dark'
    else 'danger'
    end
  end
end
