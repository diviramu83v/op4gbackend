# frozen_string_literal: true

# export data for active surveys report
class ExportActiveSurveysReportDataJob < ApplicationJob
  include ApplicationHelper
  queue_as :ui

  def perform(current_user)
    @active_surveys = Survey.active_not_draft.includes(:project).order('projects.id DESC')

    csv_file = CSV.generate do |csv|
      header(csv)
      add_csv_rows(csv)
    end

    broadcast_to_channel(current_user, csv_file)
  end

  private

  def header(csv)
    csv << ['Manager', 'WO#', 'Project Name', 'Client Name', 'Survey Name', 'CPI', 'Current Completes', 'Target Completes', 'Survey Status']
  end

  def csv_row(survey, csv) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    manager = survey.project.manager.name
    work_order = survey.project.work_order
    project_name = survey.project.extended_name
    client_name = survey.project.client.present? ? survey.project.client.name : 'N/A'
    survey_name = survey.name.presence || 'N/A'
    cpi = survey.cpi_cents.present? ? survey.cpi_cents / 100.0 : 0
    current_completes = survey.onboardings.complete.count
    target_completes = survey.target.presence || 0
    survey_status = survey.status

    csv << [manager, work_order, project_name, client_name, survey_name, format_currency_with_zeroes(cpi), format_number(current_completes),
            format_number(target_completes), survey_status]
  end

  def add_csv_rows(csv)
    @active_surveys.each do |survey|
      next if survey.blank?

      csv_row(survey, csv)
    end
  end

  def file_name(date)
    "active_projects_and_surveys_report_#{date.strftime('%m_%d_%Y')}.csv"
  end

  def broadcast_to_channel(current_user, csv_file)
    ActiveSurveysReportDownloadChannel.broadcast_to(
      current_user,
      csv_file: {
        file_name: file_name(DateTime.now.utc),
        content: csv_file
      }
    )
  end
end
