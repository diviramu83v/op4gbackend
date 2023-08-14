# frozen_string_literal: true

# This job pulls traffic records data.
class PullTrafficDataJob < ApplicationJob
  queue_as :ui

  def perform(survey)
    html = ApplicationController.render(
      partial: 'employee/surveys/traffic_content',
      locals: { survey: survey, resource: survey }
    )

    TrafficDataChannel.broadcast_to(survey, html)
  end
end
