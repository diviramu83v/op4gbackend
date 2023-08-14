# frozen_string_literal: true

require 'test_helper'

class TrafficReportsChannelTest < ActionCable::Channel::TestCase
  test 'subscribes to the traffic reports channel' do
    survey = surveys(:standard)

    subscribe survey_id: survey.id
    assert subscription.confirmed?

    assert_has_stream 'traffic_reports:all'
  end
end
