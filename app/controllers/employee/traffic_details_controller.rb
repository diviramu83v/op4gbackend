# frozen_string_literal: true

class Employee::TrafficDetailsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'
  helper_method :onboardings, :onboardings_for_page

  # rubocop:disable Metrics/AbcSize
  def show
    @survey = Survey.find(params[:survey_id])
    respond_to do |format|
      format.html { render 'employee/traffic_details/show' }
      format.csv do
        @report = @survey.traffic_reports.where(report_type: 'all-traffic').order(created_at: :desc).first

        # rubocop:disable Security/Open
        return send_data URI.open(@report.report.to_s).read, filename: @report.report_file_name, content_type: 'text/csv' if @report.present?
        # rubocop:enable Security/Open

        redirect_to survey_traffic_details_url(@survey)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def onboardings
    @onboardings ||= @survey.onboardings.most_recent_first
  end

  def onboardings_for_page
    @onboardings_for_page ||= onboardings.page(params[:page]).per(50)
  end
end
