# frozen_string_literal: true

class Employee::ProjectReportsController < Employee::BaseController
  authorize_resource

  respond_to :xlsx

  def create
    ProjectReportCreationJob.perform_later
  end

  def show
    latest_report = ProjectReport.last

    if latest_report.nil?
      flash[:alert] = 'No report found.'
      return redirect_back fallback_location: projects_url
    end

    data = URI.parse(latest_report.report.to_s).open
    send_data data.read, filename: latest_report.filename
  end
end
