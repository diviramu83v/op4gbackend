# frozen_string_literal: true

# This job pulls traffic records data.
class PullApiDisqoCompletesDataJob < ApplicationJob
  queue_as :ui

  def perform(years)
    html = ApplicationController.render(
      partial: 'employee/api_disqo/table',
      locals: { years: years }
    )

    ApiDisqoCompletesChannel.broadcast_to(years, html)
  end
end
