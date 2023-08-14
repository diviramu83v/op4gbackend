# frozen_string_literal: true

require 'test_helper'

class TrafficCheckTest < ActiveSupport::TestCase
  describe '#failed? for recaptcha' do
    setup do
      @traffic_check = traffic_checks(:pre_show)
      @traffic_check.traffic_step.update!(category: 'recaptcha')
    end

    it 'should fail if the token is invalid' do
      @traffic_check.update!(data_collected: { recaptcha_token_valid: false })

      assert @traffic_check.failed?
    end

    it 'should pass if the token is valid' do
      @traffic_check.update!(data_collected: { recaptcha_token_valid: true })

      assert_not @traffic_check.failed?
    end
  end
end
