# frozen_string_literal: true

class Employee::ApiFraudRejectsController < Employee::SupplyBaseController
  authorize_resource class: 'SurveyApiTarget'

  def show
    @date = params[:date]
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      format.csv do
        send_data ApiSurveysCsvBuilder.build_api_surveys_csv(@vendor, date: @date, completes: false),
                  type: 'text/csv', filename: "Fraud/rejected - #{@vendor.name}"
      end
    end
  end
end
