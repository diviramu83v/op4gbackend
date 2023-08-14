# frozen_string_literal: true

class Employee::DemoQueryDmasController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @dma = Dma.find(query_dma_params[:dma_id])

    @query.dmas << @dma

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @dma = Dma.find_by(id: params[:id])

    @query.dmas.delete @dma

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  private

  def query_dma_params
    params.require(:demo_query_dma).permit(:dma_id)
  end
end
