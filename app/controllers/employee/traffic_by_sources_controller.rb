# frozen_string_literal: true

class Employee::TrafficBySourcesController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @survey = Survey.find(params[:survey_id])

    render 'employee/traffic_by_source/show'
  end
end
