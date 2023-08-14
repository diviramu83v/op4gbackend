# frozen_string_literal: true

# This job pulls traffic records data.
class PullApiCintCompletesDataJob < ApplicationJob
  queue_as :ui

  def perform(years)
    html = ApplicationController.render(
      partial: 'employee/api_cint/table',
      locals: { years: years }
    )

    ApiCintCompletesChannel.broadcast_to(years, html)
  end
end
