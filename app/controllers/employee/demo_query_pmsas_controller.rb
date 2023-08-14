# frozen_string_literal: true

class Employee::DemoQueryPmsasController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @pmsa = Pmsa.find(query_pmsa_params[:pmsa_id])

    @query.pmsas << @pmsa

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @pmsa = Pmsa.find_by(id: params[:id])

    @query.pmsas.delete @pmsa

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  private

  def query_pmsa_params
    params.require(:demo_query_pmsa).permit(:pmsa_id)
  end
end
