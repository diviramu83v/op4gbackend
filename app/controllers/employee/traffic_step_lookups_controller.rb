# frozen_string_literal: true

class Employee::TrafficStepLookupsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @traffic_step_lookup = TrafficStepLookup.find(params[:id])
  end

  def new
    @traffic_step_lookup = TrafficStepLookup.new
  end

  def create
    @traffic_step_lookup = TrafficStepLookup.new(traffic_step_lookup_params)

    if @traffic_step_lookup.save
      redirect_to @traffic_step_lookup
    else
      flash[:alert] = 'Unable to create traffic step lookup'
      render 'new'
    end
  end

  private

  def traffic_step_lookup_params
    params.require(:traffic_step_lookup).permit(:uids)
  end
end
