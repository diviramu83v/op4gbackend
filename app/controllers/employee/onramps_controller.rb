# frozen_string_literal: true

class Employee::OnrampsController < Employee::OperationsBaseController
  authorize_resource

  def edit
    @onramp = Onramp.find(params[:id])
    @survey = @onramp.survey
  end

  def update
    @onramp = Onramp.find(params[:id])
    @survey = @onramp.survey

    if @onramp.update(onramp_params)
      flash[:notice] = 'Onramp updated successfully.'
      url = determine_url
      redirect_to url
    else
      render 'edit', alert: 'Unable to update onramp.'
    end
  end

  private

  def determine_url
    if @onramp.survey.recontact?
      recontact_onramps_url(@survey)
    else
      @onramp.panel? ? survey_onramps_url(@survey) : survey_vendors_url(@survey)
    end
  end

  def onramp_params
    params.require(:onramp).permit(
      :check_clean_id,
      :check_recaptcha,
      :ignore_security_flags,
      :check_gate_survey,
      :check_prescreener
    )
  end
end
