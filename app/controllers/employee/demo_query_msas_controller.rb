# frozen_string_literal: true

class Employee::DemoQueryMsasController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @msa = Msa.find(query_msa_params[:msa_id])

    @query.msas << @msa

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @msa = Msa.find_by(id: params[:id])

    @query.msas.delete @msa

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  private

  def query_msa_params
    params.require(:demo_query_msa).permit(:msa_id)
  end
end
