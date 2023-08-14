# frozen_string_literal: true

# The job exports the multi_survey traffic report data.
class ExportMultiSurveyTrafficReportDataJob
  include Sidekiq::Worker
  sidekiq_options queue: 'ui'

  def perform(current_user_id, survey_ids, report_type) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @surveys = Survey.where(id: survey_ids)
    @project = @surveys.first.project

    case report_type
    when 'all_traffic'
      @onboardings = @surveys.map(&:onboardings).flatten.sort_by { |o| o.survey.name }
    when 'completes'
      @onboardings = @surveys.map { |s| s.onboardings.live.complete }.flatten.sort_by { |o| o.survey.name }
    else
      raise 'Unexpected traffic report type.'
    end

    file = generate_csv(@onboardings)

    ActionCable.server.broadcast(
      "multi_survey_traffic_report_download_channel_#{current_user_id}",
      { csv_file: {
        file_name: "project_#{@project.id}_multi_survey_traffic_report_#{report_type}.csv",
        content: file
      } }
    )
  end

  private

  def generate_csv(onboardings) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    CSV.generate do |csv|
      csv << ['Survey', 'Status', 'Type', 'Source', 'Status', 'UID', 'Encoded UID', 'Response', 'Final status', 'LOI in minutes',
              'Survey start time', 'Survey finish time', 'Age', 'Error Message']
      onboardings.each do |onboarding|
        values = [
          onboarding.survey.name,
          onboarding.initial_survey_status,
          onboarding.category,
          onboarding.source_name,
          ApplicationController.helpers.onboarding_security_text(onboarding),
          onboarding.uid,
          onboarding.token,
          onboarding.survey_response_url.try(:slug),
          onboarding.client_status,
          onboarding.length_of_interview_in_minutes&.round(1),
          onboarding.survey_started_at&.in_time_zone('Central Time (US & Canada)')&.strftime('%Y-%m-%d %-I:%M %P %Z'),
          onboarding.survey_finished_at&.in_time_zone('Central Time (US & Canada)')&.strftime('%Y-%m-%d %-I:%M %P %Z'),
          onboarding.panelist.try(:age),
          onboarding.error_message
        ]

        csv << values
      end
    end
  end
end
