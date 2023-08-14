# frozen_string_literal: true

# The job that creates a fresh traffic report on AWS via Paperclip
class AllTrafficReportCreationJob
  include Sidekiq::Worker
  sidekiq_options queue: 'ui'

  def perform(survey_id)
    survey = Survey.find(survey_id)
    survey.traffic_reports.create!(report_type: 'all-traffic')
  end
end
