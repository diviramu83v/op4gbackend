# frozen_string_literal: true

# this contains more methods used by onboardings
module OnboardingBooleans
  def complete?
    return false if response.nil?

    survey_finished? && response.slug == 'complete'
  end

  def onboarded?
    survey_started? || survey_finished?
  end

  def never_onboarded?
    !onboarded?
  end

  def bypassed_security?
    bypassed_security_at.present?
  end

  def requires_security_checks?
    !bypassed_security?
  end

  def panelist_verified?
    panelist.present? && panelist.verified?
  end

  def run_cleanid_presurvey?
    return false if panelist_verified?

    requires_security_checks? && onramp.check_clean_id? && bypassed_all_at.blank?
  end

  def run_recaptcha_presurvey?
    return false if panelist_verified?

    requires_security_checks? && onramp.check_recaptcha? && bypassed_all_at.blank?
  end

  def run_prescreener?
    prescreener_questions.any? && onramp.check_prescreener? && bypassed_all_at.blank?
  end

  def run_gate_survey?
    check_gate_survey? && bypassed_all_at.blank?
  end

  def recaptcha_started?
    recaptcha_started_at.present?
  end

  def recaptcha_passed?
    recaptcha_passed_at.present?
  end

  def recaptcha_incomplete?
    !recaptcha_passed?
  end

  def recaptcha_too_long?
    return if recaptcha_time_in_seconds.nil?

    recaptcha_time_in_seconds >= 60
  end

  def gate_survey_attempted?
    gate_survey.present?
  end

  def gate_survey_needed_but_not_attempted?
    onramp.check_gate_survey? && !gate_survey_attempted?
  end

  def fraud_detected?
    blocked? || fraud_attempted_at.present? || failed_onboarding_at.present? || events.fraudulent.any?
  end

  def blocked_ip_address?
    return false if ip_address.nil?

    ip_address.blocked?
  end

  # TODO: Replace with status enum method.
  def finished?
    survey_finished_at.present?
  end

  def already_loaded_response_page?
    response_token_used_at.present?
  end

  def webhook_notification_sent?
    webhook_notification_sent_at.present?
  end

  def collect_followup_data?
    vendor? && batch_vendor.collect_followup_data? && complete?
  end

  def expert_recruit?
    ExpertRecruit.find_by(token: uid).present?
  end

  private

  def other_security_status?
    onramp.testing? || bypassed_security?
  end
end
