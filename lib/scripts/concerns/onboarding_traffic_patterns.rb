# frozen_string_literal: true

require_relative '../services/event_printer'

# Checks for expected traffic step/check patterns.
# Only calling this from scripts for now.
# rubocop:disable Metrics/ModuleLength
module OnboardingTrafficPatterns
  RECAPTCHA_DROPOUT = [
    'clean_id: started',
    'clean_id: passed',
    'recaptcha: started'
  ].freeze

  GATE_DROPOUT = [
    'clean_id: started',
    'clean_id: passed',
    'recaptcha: started',
    'recaptcha: passed',
    'gate_survey: started'
  ].freeze

  BLOCKED_FOR_CLEAN_ID_3_STEPS = [
    'clean_id: started',
    'clean_id: failed',
    'recaptcha: started',
    'recaptcha: passed',
    'gate_survey: started',
    'gate_survey: passed',
    'analyze: started',
    'analyze: blocked'
  ].freeze

  BLOCKED_FOR_OTHER_3_STEPS = [
    'clean_id: started',
    'clean_id: passed',
    'recaptcha: started',
    'recaptcha: passed',
    'gate_survey: started',
    'gate_survey: passed',
    'analyze: started',
    'analyze: blocked'
  ].freeze

  STARTED_3_STEPS = [
    'clean_id: started',
    'clean_id: passed',
    'recaptcha: started',
    'recaptcha: passed',
    'gate_survey: started',
    'gate_survey: passed',
    'analyze: started',
    'analyze: redirected to survey'
  ].freeze

  FINISHED_3_STEPS = [
    'clean_id: started',
    'clean_id: passed',
    'recaptcha: started',
    'recaptcha: passed',
    'gate_survey: started',
    'gate_survey: passed',
    'analyze: started',
    'analyze: redirected to survey',
    'clean_id: started',
    'clean_id: passed',
    'analyze: started',
    'analyze: passed',
    'record_response: started',
    'follow_up: started',
    'follow_up: passed',
    'redirect: started'
  ].freeze

  FINISHED_3_STEPS_NO_RETURN_CLEANID = [
    'clean_id: started',
    'clean_id: passed',
    'recaptcha: started',
    'recaptcha: passed',
    'gate_survey: started',
    'gate_survey: passed',
    'analyze: started',
    'analyze: redirected to survey',
    'analyze: started',
    'analyze: passed',
    'record_response: started',
    'follow_up: started',
    'follow_up: passed',
    'redirect: started'
  ].freeze

  FINISHED_3_STEPS_NO_RETURN_CLEANID_FOLLOWUP_ABANDONED = [
    'clean_id: started',
    'clean_id: passed',
    'recaptcha: started',
    'recaptcha: passed',
    'gate_survey: started',
    'gate_survey: passed',
    'analyze: started',
    'analyze: redirected to survey',
    'analyze: started',
    'analyze: passed',
    'record_response: started',
    'follow_up: started'
  ].freeze

  def expected_initialized_steps?
    return true if event_messages == RECAPTCHA_DROPOUT
    return true if event_messages == GATE_DROPOUT

    false
  end

  def expected_blocked_steps?
    return true if event_messages == BLOCKED_FOR_CLEAN_ID_3_STEPS
    return true if event_messages == BLOCKED_FOR_OTHER_3_STEPS

    false
  end

  def expected_screened_steps?
    false
  end

  def expected_survey_started_steps?
    return true if event_messages == STARTED_3_STEPS

    false
  end

  def expected_survey_finished_steps?
    return true if event_messages == FINISHED_3_STEPS
    return true if event_messages == FINISHED_3_STEPS_NO_RETURN_CLEANID
    return true if event_messages == FINISHED_3_STEPS_NO_RETURN_CLEANID_FOLLOWUP_ABANDONED

    false
  end

  def event_messages
    events.order(:id)
          .map(&:message)
          .reject { |message| message.start_with?('redirected to:') }
  end

  def print_traffic_data
    puts status.upcase
    puts "created_at: #{created_at}"
    puts "survey_started_at: #{survey_started_at}"
    puts "survey_finished_at: #{survey_finished_at}"

    events.find_each do |event|
      EventPrinter.new(event: event).print
    end

    puts "https://admin.op4g.com/onboarding/#{id}/traffic_steps"
    puts "https://admin.op4g.com/onboarding/#{id}/traffic_events"

    puts
  end
end
# rubocop:enable Metrics/ModuleLength
