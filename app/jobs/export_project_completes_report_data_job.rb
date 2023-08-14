# frozen_string_literal: true

# The job exports the project completes report data.
class ExportProjectCompletesReportDataJob
  include Sidekiq::Worker
  sidekiq_options queue: 'ui'

  def perform(current_user_id, project_id) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @project = Project.find(project_id)
    file = CSV.generate do |csv|
      csv << %w[Vendor Survey UID Response Final_Status Rejection_Reason]
      @project.onboardings.complete.sort_by { |o| [o.source.name, o.survey.name] }.each do |onboarding|
        values = [
          onboarding.source.name,
          onboarding.survey.name,
          onboarding.uid,
          onboarding.survey_response_url.slug,
          onboarding.project_closeout_status,
          onboarding.try(:rejected_reason)
        ]

        csv << values
      end
    end

    ActionCable.server.broadcast(
      "project_completes_report_download_channel_#{current_user_id}",
      { csv_file: {
        file_name: "project_#{@project.id}_close_out_completes_report.csv",
        content: file
      } }
    )
  end
end
