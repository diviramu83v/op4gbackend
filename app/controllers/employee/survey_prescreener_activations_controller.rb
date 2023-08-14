# frozen_string_literal: true

class Employee::SurveyPrescreenerActivationsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'
  authorize_resource class: 'Onramp'

  # Asynchronous.
  def create
    @survey = Survey.find(params[:survey_id])
    render 'error', locals: { message: screener_on_alert_message } unless @survey.turn_prescreener_on
  end

  # Asynchronous.
  def destroy
    @survey = Survey.find(params[:survey_id])
    render 'error', locals: { message: 'Unable to turn screener off.' } unless @survey.turn_prescreener_off
  end

  private

  def screener_on_alert_message
    if @survey.prescreener_question_templates.active.empty?
      'Unable to turn screener on. Please add screener questions first.'
    else
      'Unable to turn screener on.'
    end
  end
end
