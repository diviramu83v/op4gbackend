# frozen_string_literal: true

class Employee::SurveyCompletionsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  # rubocop:disable Metrics/AbcSize
  def show
    @survey = Survey.find(params[:survey_id])

    respond_to do |format|
      format.csv do
        @report = @survey.traffic_reports.where(report_type: 'completes').order(created_at: :desc).first

        # rubocop:disable Security/Open
        return send_data URI.open(@report.report.to_s).read, filename: @report.report_file_name, content_type: 'text/csv' if @report.present?
        # rubocop:enable Security/Open

        flash[:alert] = 'No report found.'
        redirect_to survey_traffic_details_url(@survey)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
end
