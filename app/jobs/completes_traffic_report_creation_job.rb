# frozen_string_literal: true

# The job that creates a fresh traffic report on AWS via Paperclip
class CompletesTrafficReportCreationJob < ApplicationJob
  queue_as :ui

  def perform(survey)
    survey.traffic_reports.create!(report_type: 'completes')
  end
end
