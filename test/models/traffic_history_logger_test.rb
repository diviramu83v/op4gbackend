# frozen_string_literal: true

require 'test_helper'

class TrafficHistoryLoggerTest < ActiveSupport::TestCase
  setup do
    @onboarding = onboardings(:standard)
    @history_logger = TrafficHistoryLogger.new(onboarding: @onboarding)
  end

  describe 'run' do
    it 'logs information about the given onboarding' do
      @history_logger.run
    end

    it 'logs about fraudulent events, if any are present on the onboarding' do
      traffic_event = TrafficEvent.new(category: 'fraud', message: 'fraud event', created_at: Time.now.utc)
      @onboarding.events << traffic_event
      @history_logger.run
    end
  end

  describe 'recaptcha_output' do
    it 'prints info about the recaptcha interaction for this onboarding' do
      start_time = Time.now.utc
      end_time = start_time + 10.minutes

      @onboarding.recaptcha_started_at = start_time
      @onboarding.recaptcha_passed_at = end_time
      output = @history_logger.recaptcha_output

      assert_equal true, output == "RECAPTCHA started:#{start_time} / finished:#{end_time}"
    end

    it 'prints info about the recaptcha interaction not being finished' do
      now = Time.now.utc
      @onboarding.recaptcha_started_at = now
      output = @history_logger.recaptcha_output

      assert_equal true, output == "RECAPTCHA started:#{now} / NEVER FINISHED"
    end
  end

  describe 'survey_output' do
    it 'prints info about the survey for this onboarding' do
      start_time = Time.now.utc
      end_time = start_time + 10.minutes

      @onboarding.survey_started_at = start_time
      @onboarding.survey_finished_at = end_time
      output = @history_logger.survey_output

      assert_equal true, output == "SURVEY: started:#{start_time} / finished:#{end_time}"
    end

    it 'prints info about the survey not being finished' do
      now = Time.now.utc
      @onboarding.survey_started_at = now
      output = @history_logger.survey_output

      assert_equal true, output == "SURVEY: started:#{now} / NEVER FINISHED"
    end
  end

  describe 'self.print_for_tokens' do
    it 'prints the traffic history logger info for each token provided' do
      TrafficHistoryLogger.any_instance.expects(:run).at_least_once
      TrafficHistoryLogger.print_for_tokens(tokens: %w[abc 123])
    end
  end

  describe 'self.print_for_ip' do
    it 'reports \'no matches found\' when no matching ip is found' do
      TrafficHistoryLogger.any_instance.expects(:run).never
      TrafficHistoryLogger.print_for_ip(address: '1.1.1.1')
    end

    it 'prints the traffic history logger info for each found ip address' do
      ip_address = ip_addresses(:standard)
      TrafficHistoryLogger.any_instance.expects(:run).at_least_once
      TrafficHistoryLogger.print_for_ip(address: ip_address.address)
    end
  end
end
