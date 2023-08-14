# frozen_string_literal: true

class Employee::FeasibilitiesController < Employee::SalesBaseController
  include SetFeasibilityTotal

  authorize_resource class: 'Panel'

  # rubocop:disable Metrics/AbcSize
  def index
    @feasibility_queries = DemoQuery.feasibility.most_recent.page(params[:page]).per(25)

    return render if params[:employee_id].blank?

    @selected_employee = Employee.find(params[:employee_id])
    @feasibility_queries = DemoQuery.feasibility.where(employee: @selected_employee).most_recent.page(params[:page]).per(25)
  end
  # rubocop:enable Metrics/AbcSize

  def new
    @panels = Panel.active.sort_by(&:active_panelist_count).reverse
    @clients = Client.by_name
  end

  def show
    @query = DemoQuery.find(params[:id])
  end

  def create
    @query = DemoQuery.new(query_params)
    @query.employee = current_employee
    save_feasibility_total(@query)

    if @query.save
      redirect_to feasibility_url(@query)
    else
      # Redirecting here instead of _render 'new'_. Seems cleaner than
      # reloading the @panels variable and rendering again. Seems unlikely that
      # we'll need to show an error message or anything in the case that the
      # panel is invalid.
      redirect_to new_feasibility_url
    end
  end

  private

  def query_params
    params.require(:feasibility).permit(:panel_id, :client_id, :feasibility_total)
  end
end
