# frozen_string_literal: true

# This controller handles the display of steps for a given project. Mostly
#   just making sure we get to the view for the right step.
class Employee::GateSurveysController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def index
    @survey = Survey.find(params[:survey_id])

    respond_to do |format|
      format.html
      format.csv do
        send_data @survey.gate_surveys.to_csv
      end
    end
  end
end
