# frozen_string_literal: true

# This controller shoes the traffic steps for an onboarding record
class Employee::TrafficEventsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def index
    @onboarding = Onboarding.find(params[:onboarding_id])
    @traffic_details_url = traffic_details_url
  end

  private

  def traffic_details_url
    @onboarding.onramp.recontact? ? recontact_traffic_details_url(@onboarding.survey) : survey_traffic_details_url(@onboarding.survey)
  end
end
