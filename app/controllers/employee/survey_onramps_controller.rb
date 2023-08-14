# frozen_string_literal: true

class Employee::SurveyOnrampsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'
  def show
    @survey = Survey.find(params[:survey_id])
  end
end
