# frozen_string_literal: true

class Employee::CintFeasibilityCountryOptionsController < Employee::OperationsBaseController
  authorize_resource class: 'Panel'

  def create
    @options = CintApi.new.country_demo_options(country_id: params[:country_id].to_i) if params[:country_id].present?
    @url = params[:url]
    render 'create'
  end
end
