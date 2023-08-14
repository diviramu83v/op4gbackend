# frozen_string_literal: true

class Employee::DemoQueryRegionsController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @region = Region.find_by(id: params[:region_id])

    @query.regions << @region if @region.present?

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @region = Region.find_by(id: params[:id])

    @query.regions.delete @region if @region.present?

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end
end
