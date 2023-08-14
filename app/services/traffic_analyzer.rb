# frozen_string_literal: true

# a service for analyzing traffic
class TrafficAnalyzer
  def initialize(onboarding:, test_mode: false, request: nil)
    @onboarding = onboarding
    @test_mode = test_mode
    @request = request
  end

  def failed_pre_survey?
    return false if test_mode_on? || onramp_security_off?

    ip_blocked? || browser_is_a_crawler? || pre_survey_steps_failed?
  end

  def failed_post_survey?
    return false if test_mode_on? || onramp_security_off?
    return unless @onboarding.survey_response_url&.slug.presence == 'complete'

    failed_clean_id? || failed_return_key?
  end

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def flagged_post_survey?
    return false if test_mode_on? || onramp_security_off?
    return unless @onboarding.survey_response_url&.slug.presence == 'complete'

    ip_blocked? || browser_is_a_crawler? || some_steps_incomplete? || post_survey_steps_failed?
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def failed_prescreener?
    return false unless @onboarding.onramp.check_prescreener?

    @onboarding.prescreener_questions.complete.map(&:question_failed?).any?(true)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def failed_reason
    return pre_survey_steps_failed_reasons.first if pre_survey_steps_failed?
    return 'Bad return key' if failed_return_key?
    return 'IP blocked' if ip_blocked?
    return 'Prescreener failed' if failed_prescreener?
    return 'Some steps incomplete' if some_steps_incomplete?
    # return 'IP inconsistent' if ip_inconsistent?
    return post_survey_steps_failed_reasons.first if post_survey_steps_failed?
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def test_mode_on?
    @test_mode == true
  end

  def onramp_security_off?
    @onboarding.onramp.ignore_security_flags?
  end

  def pre_survey_steps_failed?
    pre_survey_steps_failed_reasons.any?
  end

  def pre_survey_steps_failed_reasons
    @onboarding.traffic_steps.pre_survey.by_sort_order.select(&:failed?).map do |traffic_step|
      format_failed_reason(traffic_step)
    end
  end

  def format_failed_reason(traffic_step)
    if traffic_step.category == 'clean_id' || traffic_step.category == 'recaptcha'
      "#{traffic_step.formatted_category}: #{traffic_step.failed_reason}"
    else
      traffic_step.formatted_category
    end
  end

  def post_survey_steps_failed?
    post_survey_steps_failed_reasons.any?
  end

  def post_survey_steps_failed_reasons
    @onboarding.traffic_steps.post_survey.by_sort_order.select(&:failed?).map(&:category)
  end

  def failed_clean_id?
    CleanIdDataVerification.new(data: @onboarding.clean_id_data, onboarding: @onboarding).fails_any_checks?
  end

  def failed_return_key?
    ReturnKeyAnalyzer.new(onboarding: @onboarding).bad_key?
  end

  def browser_is_a_crawler?
    return if @request.blank?

    Rails.logger.info("A crawler browser has been detected. Onboarding id #{@onboarding.id}") if @request.is_crawler?
  end

  def ip_inconsistent?
    @onboarding.traffic_checks.map { |check| check.ip_address.address }.uniq.count > 1
  end

  def ip_blocked?
    @onboarding.traffic_checks.map(&:ip_address).uniq.any?(:blocked?)
  end

  def some_steps_incomplete?
    @onboarding.traffic_steps.where.not(category: %w[redirect record_response follow_up]).any?(&:incomplete?)
  end
end
