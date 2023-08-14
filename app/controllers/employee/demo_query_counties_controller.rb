# frozen_string_literal: true

class Employee::DemoQueryCountiesController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @county = County.find(query_county_params[:county_id])

    @query.counties << @county

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @county = County.find_by(id: params[:id])

    @query.counties.delete @county

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  private

  def query_county_params
    params.require(:demo_query_county).permit(:county_id)
  end
end
