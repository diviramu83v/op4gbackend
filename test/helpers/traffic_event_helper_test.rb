# frozen_string_literal: true

require 'test_helper'

class TrafficEventHelperTest < ActionView::TestCase
  describe '#format_message' do
    test 'capitalizes message slugs' do
      assert_equal 'CleanID: message', format_message('clean_id: message')
      assert_equal 'ReCaptcha: message', format_message('recaptcha: message')
      assert_equal 'Gate Survey: message', format_message('gate_survey: message')
      assert_equal 'Analyze: message', format_message('analyze: message')
      assert_equal 'Follow Up: message', format_message('follow_up: message')
      assert_equal 'Record Response: message', format_message('record_response: message')
      assert_equal 'Redirect: message', format_message('redirect: message')
      assert_equal 'unexpected: message', format_message('unexpected: message')
    end
  end

  describe '#format_pre_or_post' do
    test 'capitalizes and adds "-survey"' do
      assert_equal 'Pre-survey', format_pre_or_post('pre')
      assert_equal 'Post-survey', format_pre_or_post('post')
    end
  end
end
