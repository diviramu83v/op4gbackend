# frozen_string_literal: true

class Employee::ApiCompletesController < Employee::SupplyBaseController
  authorize_resource class: 'SurveyApiTarget'

  def show
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      format.csv do
        send_data ApiSurveysCsvBuilder.build_api_surveys_csv(@vendor), type: 'text/csv', filename: "Completes - #{@vendor.name}"
      end
    end
  end
end
