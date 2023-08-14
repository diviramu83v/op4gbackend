# frozen_string_literal: true

class Employee::TrafficRecordsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @onboarding = Onboarding.find(params[:id])
    @survey = @onboarding.survey
  end
end
