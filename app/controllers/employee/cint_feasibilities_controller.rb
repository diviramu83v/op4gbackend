# frozen_string_literal: true

class Employee::CintFeasibilitiesController < Employee::SalesBaseController
  authorize_resource class: 'Panel'

  before_action :set_age_range, only: [:new, :create]
  before_action :build_country_options, only: [:new, :create]
  before_action :build_state_options, only: [:new, :create]
  before_action :build_city_options, only: [:new, :create]

  def index
    @feasibilities = CintFeasibility.most_recent.page(params[:page]).per(10)
    @filter_employees = Employee.joins(:cint_feasibilities).uniq
    @selected_employee = Employee.find_by(id: params[:employee_id])
    return if @selected_employee.blank?

    @feasibilities = @feasibilities.where(employee: @selected_employee)
  end

  def new
    @feasibility = CintFeasibility.new
  end

  def create
    @feasibility = CintFeasibility.new(feasibility_params.merge(employee: current_employee))
    @feasibility.variable_ids = reject_blank_values(feasibility_options_params.to_h)
    if @feasibility.save
      flash[:notice] = 'Cint feasibility saved successfully.'
      redirect_to cint_feasibilities_url(@feasibility)
    else
      render 'new'
    end
  end

  private

  def build_country_options
    countries = CintApi.new.countries_hash
    @countries_options = []
    countries.each do |country|
      next unless country['name'] == 'USA'

      @countries_options.push([country['name'], country['id']])
    end
  end

  def build_state_options
    region_types = build_region_types
    @states = []
    region_types[0][4]['regions'].each do |state|
      @states.push({ name: state['name'], id: state['id'] })
    end
  end

  def build_city_options
    region_types = build_region_types
    @cities = []
    region_types[0][3]['regions'].each do |city|
      @cities.push({ name: city['name'], id: city['id'] })
    end
  end

  def build_region_types
    countries = CintApi.new.countries_hash
    region_types = []
    countries.each do |country|
      next unless country['name'] == 'USA'

      region_types.push(country['regionTypes'])
    end
    region_types
  end

  def set_age_range
    @age_range = 18..99
  end

  def feasibility_params
    params.require(:cint_feasibility).permit(
      :days_in_field, :incidence_rate, :loi, :limit, :country_id, :min_age, :max_age, :gender, :variable_ids, :number_of_panelists, :postal_codes,
      region_ids: []
    )
  end

  def feasibility_options_params
    params.require(:options).permit!
  end

  def reject_blank_values(feasibility_options_params)
    feasibility_options_params&.to_h&.values&.flatten&.reject(&:blank?)
  end
end
