# frozen_string_literal: true

# this is for the Disqo API's Quota Feasibilities
class Employee::DisqoFeasibilitiesController < Employee::SalesBaseController
  authorize_resource class: 'Panel'

  def index
    @feasibilities = DisqoFeasibility.most_recent.page(params[:page]).per(10)
    @filter_employees = Employee.joins(:disqo_feasibilities).uniq
    @selected_employee = Employee.find_by(id: params[:employee_id])
    return if @selected_employee.blank?

    @feasibilities = @feasibilities.where(employee: @selected_employee)
  end

  def new
    @feasibility = DisqoFeasibility.new
  end

  def create
    @feasibility = DisqoFeasibility.new(feasibility_params.merge(employee: current_employee))
    @feasibility.qualifications = QuotaQualificationsData.new(qualifications_params).qualifications_hash
    if @feasibility.save
      flash[:notice] = 'Disqo Feasibility successfully created.'
      redirect_to disqo_feasibilities_url
    else
      render 'new'
    end
  end

  private

  def feasibility_params
    params.require(:disqo_feasibility).permit(:loi, :completes_wanted, :days_in_field, :incidence_rate)
  end

  # rubocop:disable Metrics/MethodLength, Style/HashAsLastArrayItem
  def qualifications_params
    params.require(:disqo_feasibility).permit(
      qualifications: [
        :geopostalcode,
        :geodmaregioncode,
        :geocountry,
        age: [:min_age, :max_age],
        anychildage: [:min_age, :max_age],
        gender: [],
        georegion: [],
        groceryshoppingduty: [],
        rentorown: [],
        ethnicity: [],
        educationlevel: [],
        householdincome: [],
        employmentstatus: [],
        industry: [],
        jobposition: [],
        employeecount: [],
        children: []
      ]
    )[:qualifications]
  end
  # rubocop:enable Metrics/MethodLength, Style/HashAsLastArrayItem
end
