# frozen_string_literal: true

# Prints security output/onboarding process for IDs or groups of IDs.
# USAGE:
#   rails console
#   > TrafficHistoryLogger.print_for_ip(address: '24.46.127.33')
#   > TrafficHistoryLogger.print_for_tokens(tokens: ['1027dc64344712570a4ecb1f24343c'])
#   > TrafficHistoryLogger.print_for_tokens(tokens: ['1027dc64344712570a4ecb1f24343c', 'tycq8PQFHFLB1n99bhj4MUhY'])
class TrafficHistoryLogger
  @log_levels = []

  class << self
    def push_log_level(level)
      @log_levels.push(level)
    end

    def suppress_database_logging
      Rails.logger.level = :info
    end

    def pop_log_level
      @log_levels.pop
    end
  end

  def initialize(onboarding:)
    @onboarding = onboarding
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def run
    self.class.push_log_level Rails.logger.level
    self.class.suppress_database_logging

    Rails.logger.info "RECORD: uid:#{@onboarding.uid} / token:#{@onboarding.token} / ip:#{@onboarding.ip_address.address}"

    if @onboarding.onramp_id.present?
      Rails.logger.info "ONRAMP: #{@onboarding.onramp_id}:#{@onboarding.onramp.category}:#{@onboarding.onramp.source_model_name}"
    end

    Rails.logger.info "BYPASSED SECURITY: #{@onboarding.bypassed_security_at}" if @onboarding.bypassed_security_at.present?

    Rails.logger.info 'BLOCKED IP' if @onboarding.blocked_ip_address? && @onboarding.created_at >= @onboarding.ip_address.blocked_at

    Rails.logger.info 'FRAUD DETECTED' if @onboarding.fraud_detected?
    Rails.logger.info "- fraud attempted: #{@onboarding.fraud_attempted_at}" if @onboarding.fraud_attempted_at.present?
    if @onboarding.events.fraudulent.any?
      Rails.logger.info '- fraud events'
      @onboarding.events.fraudulent.each do |event|
        Rails.logger.info "  - [#{event.category}] #{event.message}:#{event.created_at}"
      end
    end

    Rails.logger.info "FAILED ONBOARDING: #{@onboarding.failed_onboarding_at}" if @onboarding.failed_onboarding_at.present?
    Rails.logger.info "- error message: #{@onboarding.error_message}" if @onboarding.error_message.present?

    Rails.logger.info "STATUS: #{@onboarding.initial_survey_status}" if @onboarding.initial_survey_status.present?

    Rails.logger.info recaptcha_output if recaptcha_output.present?

    Rails.logger.info survey_output if survey_output.present?

    Rails.logger.info "RESPONSE: #{@onboarding.survey_response_url.slug.upcase}" if @onboarding.survey_response_url_id.present?

    Rails.logger.info "RESPONSE PAGE: #{@onboarding.response_page_loaded_at}" if @onboarding.response_page_loaded_at.present?
    Rails.logger.info "RESPONSE TOKEN: #{@onboarding.response_token_used_at}" if @onboarding.response_token_used_at.present?
    Rails.logger.info "WEBHOOK: #{@onboarding.webhook_notification_sent_at}" if @onboarding.webhook_notification_sent_at.present?

    Rails.logger.info "ATTEMPTED AGAIN: #{@onboarding.attempted_again_at}" if @onboarding.attempted_again_at.present?

    # Rails.logger.info created_at
    # Rails.logger.info updated_at
    # Rails.logger.info recaptcha_token
    # Rails.logger.info gate_survey_token
    # Rails.logger.info error_message
    # Rails.logger.info panelist_id
    # Rails.logger.info response_token
    # Rails.logger.info error_token
    # Rails.logger.info email
    # Rails.logger.info affiliate_code
    # Rails.logger.info sub_affiliate_code
    # Rails.logger.info panel_id
    # Rails.logger.info project_invitation_id
    # Rails.logger.info onboarding_token
    # Rails.logger.info visit_code

    Rails.logger.level = self.class.pop_log_level
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def recaptcha_output
    return if @onboarding.recaptcha_started_at.blank?

    output = "RECAPTCHA started:#{@onboarding.recaptcha_started_at}"
    output + if @onboarding.recaptcha_passed_at.present?
               " / finished:#{@onboarding.recaptcha_passed_at}"
             else
               ' / NEVER FINISHED'
             end
  end

  def survey_output
    return if @onboarding.survey_started_at.blank?

    output = "SURVEY: started:#{@onboarding.survey_started_at}"
    output + if @onboarding.survey_finished_at.present?
               " / finished:#{@onboarding.survey_finished_at}"
             else
               ' / NEVER FINISHED'
             end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.print_for_tokens(tokens:)
    push_log_level Rails.logger.level
    suppress_database_logging

    tokens.each do |token|
      onboarding = Onboarding.find_by(uid: token)
      Rails.logger.info "#{token}: NOT FOUND" if onboarding.nil?
      next if onboarding.nil?

      TrafficHistoryLogger.new(onboarding: onboarding).run
      Rails.logger.info ''
    end

    Rails.logger.level = pop_log_level

    nil
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.print_for_ip(address:)
    push_log_level Rails.logger.level
    suppress_database_logging

    Rails.logger.info ''

    ip = IpAddress.find_by(address: address)

    if ip.nil?
      Rails.logger.info 'No matching IP address found'
    else
      ip.onboardings.order(:created_at).each do |onboarding|
        TrafficHistoryLogger.new(onboarding: onboarding).run
        Rails.logger.info ''
      end
    end

    Rails.logger.level = pop_log_level

    nil
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
