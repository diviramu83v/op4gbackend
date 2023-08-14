# frozen_string_literal: true

class Employee::SurveyCpisController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  # AJAX
  def update
    @survey = Survey.find(params[:survey_id])

    render if @survey.update(survey_params)
  end

  private

  def survey_params
    params.require(:survey).permit(:cpi)
  end
end
