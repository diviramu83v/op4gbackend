# frozen_string_literal: true

# This job pulls traffic records data.
class PullApiDisqoSingleYearCompletesDataJob < ApplicationJob
  queue_as :ui

  def perform(completes_by_month)
    html = ApplicationController.render(
      partial: 'employee/api_disqo_single_year_completes/table',
      locals: { completes_by_month: completes_by_month }
    )

    ApiDisqoSingleYearCompletesChannel.broadcast_to(completes_by_month, html)
  end
end
