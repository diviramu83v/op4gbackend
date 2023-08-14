# frozen_string_literal: true

class Employee::VendorStatsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @onramp = Onramp.find(params[:onramp_id])

    respond_to do |format|
      format.csv do
        filename = formatted_filename

        send_data @onramp.to_csv, filename: filename
      end
    end
  end

  def formatted_filename
    filename = "#{@onramp.project.work_order}-#{@onramp.survey.name}-#{@onramp.vendor_name}"
    filename += "-#{@onramp.disqo_quota.quota_id}" if @onramp.disqo?
    filename += "-#{@onramp.cint_survey.cint_id}" if @onramp.cint?
    "#{filename}.csv"
  end
end
