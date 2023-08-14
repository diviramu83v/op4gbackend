# frozen_string_literal: true

class Employee::DemoQueryStatesController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @state = State.find_by(id: params[:state_id])

    @query.states << @state if @state.present?

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @state = State.find_by(id: params[:id])

    @query.states.delete @state if @state.present?

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end
end
