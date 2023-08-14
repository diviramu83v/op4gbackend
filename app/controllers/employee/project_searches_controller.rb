# frozen_string_literal: true

class Employee::ProjectSearchesController < Employee::OperationsBaseController
  skip_authorization_check

  # rubocop:disable Metrics/AbcSize
  def create
    search_term = params[:project_search][:project_work_order_or_survey_number]

    result = Project.find_by(id: search_term) || Project.find_by(work_order: search_term)

    return redirect_to project_path(id: result[:id]) if result.present?

    result = Project.search_by_name(search_term).first

    return redirect_to project_path(id: result[:id]) if result.present?

    result = Survey.find_by(id: search_term)

    return redirect_to survey_path(id: result[:id]) if result.present?

    flash[:alert] = 'Project or survey not found'
    redirect_to employee_dashboard_path
  end
  # rubocop:enable Metrics/AbcSize
end
