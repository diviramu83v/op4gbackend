# frozen_string_literal: true

class Employee::PersonalProjectReportsController < Employee::BaseController
  authorize_resource class: 'ProjectReport'

  # rubocop:disable Metrics/MethodLength
  def show
    @projects = projects_for_status(params[:status])

    respond_to do |format|
      format.csv do
        csv_file = CSV.generate do |csv|
          csv << ['ID', 'WO', 'Status', 'Client', 'Project', 'Survey', 'Type', 'Manager', 'Salesperson', 'Created',
                  'CPI', 'Original Quota', 'Current Progress', 'Original Value', 'Current Value', 'Started', 'Ended']

          @projects.each do |project|
            project.surveys.each do |survey|
              csv << report_row(survey)
            end
          end
        end

        send_data csv_file
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def report_row(survey)
    [
      survey.project.id,
      value_or_question_mark(survey.project.work_order),
      survey.status,
      value_or_question_mark(survey.project.client.try(:name)),
      survey.project.name,
      survey.name,
      value_or_question_mark(survey.project.product_name),
      survey.project.manager.name,
      value_or_question_mark(survey.project.salesperson.try(:name)),
      format_excel_date(survey.project.created_at),
      value_or_question_mark(survey.cpi),
      value_or_question_mark(survey.target),
      value_or_question_mark(survey.adjusted_complete_count),
      value_or_question_mark(survey.value),
      format_excel_date(survey.project.started_at),
      format_excel_date(survey.project.finished_at)
    ]
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def projects_for_status(status)
    case status
    when 'all'    then Project.for_manager(current_employee)
    when 'active' then Project.for_manager(current_employee).active
    else Project.for_manager(current_employee).joins(:surveys).merge(Survey.where(status: status)).distinct
    end.order('projects.id DESC').includes(:manager, :client, :salesperson, :surveys)
  end

  def value_or_question_mark(value)
    value.presence || '?'
  end

  def format_excel_date(date)
    return if date.blank?

    date.strftime('%-m/%-d/%Y')
  end
end
