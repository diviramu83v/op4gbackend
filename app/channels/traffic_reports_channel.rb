# frozen_string_literal: true

# Handle subscriptions to system events.
class TrafficReportsChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to traffic reports channel.'
    survey = Survey.find(params[:survey_id])

    CompletesTrafficReportCreationJob.perform_later(survey) if params[:report_type] == 'all-traffic'
    AllTrafficReportCreationJob.perform_async(survey.id) if params[:report_type] == 'completes'

    stream_for 'all'
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from traffic reports channel.'
  end
end
