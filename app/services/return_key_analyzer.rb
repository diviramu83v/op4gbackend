# frozen_string_literal: true

# a service for analyzing return keys
class ReturnKeyAnalyzer
  def initialize(onboarding:)
    @onboarding = onboarding
  end

  def bad_key?
    return false unless @onboarding.survey.uses_return_keys?

    missing_or_invalid? || onboarding_previously_used? || return_key_previously_used? || mismatched_survey?
  end

  private

  def missing_or_invalid?
    @onboarding.return_key_onboardings.empty?
  end

  def onboarding_previously_used?
    @onboarding.return_key_onboardings.count > 1
  end

  def return_key_previously_used?
    latest_key.return_key_onboardings.count > 1
  end

  def mismatched_survey?
    @onboarding.survey != latest_key.survey
  end

  def latest_key
    @latest_key ||= @onboarding.return_key_onboardings.last.return_key
  end
end
