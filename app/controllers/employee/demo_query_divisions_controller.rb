# frozen_string_literal: true

class Employee::DemoQueryDivisionsController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @division = Division.find_by(id: params[:division_id])

    @query.divisions << @division if @division.present?

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @division = Division.find_by(id: params[:id])

    @query.divisions.delete @division if @division.present?

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end
end
