# frozen_string_literal: true

class Employee::OnrampPrescreenerActivationsController < Employee::OperationsBaseController
  authorize_resource class: 'Onramp'

  # Asynchronous.
  def create
    @onramp = Onramp.find(params[:onramp_id])
    render 'error', locals: { message: screener_on_alert_message } unless @onramp.update(check_prescreener: true)
  end

  # Asynchronous.
  def destroy
    @onramp = Onramp.find(params[:onramp_id])
    render 'error', locals: { message: 'Unable to turn screener off.' } unless @onramp.update(check_prescreener: false)
  end

  private

  def screener_on_alert_message
    if @onramp.prescreener_question_templates.active.empty?
      'Unable to turn screener on. Please add screener questions first.'
    else
      'Unable to turn screener on.'
    end
  end
end
