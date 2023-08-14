# frozen_string_literal: true

class Employee::SurveyBlockReasonsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def index
    @survey = Survey.find(params[:survey_id])
  end
end
