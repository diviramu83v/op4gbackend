# frozen_string_literal: true

class Employee::OnrampDisablingsController < Employee::OperationsBaseController
  authorize_resource class: 'Onramp'

  before_action :load_onramp

  def create
    @onramp.disable!
    handle_redirection
  end

  def destroy
    @onramp.enable!
    handle_redirection
  end

  private

  def load_onramp
    @onramp = Onramp.find(params[:onramp_id])
  end

  def handle_redirection
    if @onramp.batch_vendor.present?
      redirect_to survey_vendors_url(@onramp.survey, anchor: "vendor-#{@onramp.batch_vendor.id}")
    else
      redirect_to survey_onramps_url(@onramp.survey)
    end
  end
end
