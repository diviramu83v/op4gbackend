# frozen_string_literal: true

require 'test_helper'

require_relative '../../lib/scripts/concerns/onboarding_traffic_patterns'
Onboarding.prepend(OnboardingTrafficPatterns)

class OnboardingTrafficPatternTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @onboarding = onboardings(:standard)
    @onboarding.events.delete_all
    assert @onboarding.events.empty?
  end

  describe '#event_messages' do
    test 'returns expected messages' do
      @onboarding.events.create!(category: 'info', message: 'test 1')
      @onboarding.events.create!(category: 'info', message: 'test 2')
      @onboarding.events.create!(category: 'info', message: 'redirected to: https://somewhere.com')

      assert_equal ['test 1', 'test 2'], @onboarding.event_messages
    end
  end

  describe '#expected_initialized_steps?' do
    test 'recaptcha dropout' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')

      assert @onboarding.expected_initialized_steps?
    end

    test 'gate dropout' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: passed')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: started')

      assert @onboarding.expected_initialized_steps?
    end

    test 'anomaly' do
      @onboarding.events.create!(category: 'info', message: 'something unexpected')

      assert_not @onboarding.expected_initialized_steps?
    end
  end

  describe '#expected_blocked_steps?' do
    test 'CleanId block' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: failed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: passed')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: started')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: passed')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: blocked')

      assert @onboarding.expected_blocked_steps?
    end

    test 'non-CleanID block' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: passed')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: started')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: passed')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: blocked')

      assert @onboarding.expected_blocked_steps?
    end

    test 'anomaly' do
      @onboarding.events.create!(category: 'info', message: 'something unexpected')

      assert_not @onboarding.expected_blocked_steps?
    end
  end

  describe '#expected_screened_steps?' do
    test 'anomaly' do
      @onboarding.events.create!(category: 'info', message: 'something unexpected')

      assert_not @onboarding.expected_screened_steps?
    end
  end

  describe '#expected_survey_started_steps?' do
    test 'passed 3 steps' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: passed')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: started')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: passed')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: redirected to survey')

      assert @onboarding.expected_survey_started_steps?
    end

    test 'anomaly' do
      @onboarding.events.create!(category: 'info', message: 'something unexpected')

      assert_not @onboarding.expected_survey_started_steps?
    end
  end

  describe '#expected_survey_finished_steps?' do
    test 'passed everything' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: passed')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: started')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: passed')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: redirected to survey')
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: passed')
      @onboarding.events.create!(category: 'info', message: 'record_response: started')
      @onboarding.events.create!(category: 'info', message: 'follow_up: started')
      @onboarding.events.create!(category: 'info', message: 'follow_up: passed')
      @onboarding.events.create!(category: 'info', message: 'redirect: started')

      assert @onboarding.expected_survey_finished_steps?
    end

    test 'passed everything but no CleanID' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: passed')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: started')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: passed')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: redirected to survey')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: passed')
      @onboarding.events.create!(category: 'info', message: 'record_response: started')
      @onboarding.events.create!(category: 'info', message: 'follow_up: started')
      @onboarding.events.create!(category: 'info', message: 'follow_up: passed')
      @onboarding.events.create!(category: 'info', message: 'redirect: started')

      assert @onboarding.expected_survey_finished_steps?
    end

    test 'passed everything but no CleanID and skipped follow-up' do
      @onboarding.events.create!(category: 'info', message: 'clean_id: started')
      @onboarding.events.create!(category: 'info', message: 'clean_id: passed')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: started')
      @onboarding.events.create!(category: 'info', message: 'recaptcha: passed')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: started')
      @onboarding.events.create!(category: 'info', message: 'gate_survey: passed')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: redirected to survey')
      @onboarding.events.create!(category: 'info', message: 'analyze: started')
      @onboarding.events.create!(category: 'info', message: 'analyze: passed')
      @onboarding.events.create!(category: 'info', message: 'record_response: started')
      @onboarding.events.create!(category: 'info', message: 'follow_up: started')

      assert @onboarding.expected_survey_finished_steps?
    end

    test 'anomaly' do
      assert_not @onboarding.expected_survey_finished_steps?
    end
  end

  describe '#print_traffic_data' do
    test 'calls event printer for each event' do
      @onboarding.events.create!(category: 'info', message: 'test 1')
      @onboarding.events.create!(category: 'info', message: 'test 2')

      IO.any_instance.expects(:puts).times(7)
      EventPrinter.any_instance.expects(:print).twice

      @onboarding.print_traffic_data
    end
  end
end
