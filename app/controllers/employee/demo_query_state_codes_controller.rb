# frozen_string_literal: true

class Employee::DemoQueryStateCodesController < Employee::OperationsBaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  # rubocop:disable Metrics/AbcSize
  def create
    @query = DemoQuery.find(params[:query_id])
    @state_code = params[:code]
    @country = Country.find_by(id: params[:country_id])

    begin
      flash.now[:alert] = 'Unable to add state code filter.' unless @query.demo_query_state_codes.create(code: @state_code)

      render json: render_demo_query_options
    rescue ActiveRecord::RecordNotUnique
      render json: render_demo_query_options
    end

    save_feasibility_total(@query)
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @code = params[:id]
    @country = Country.find_by(id: params[:country_id])

    return if @query.demo_query_state_codes.blank? || @query.demo_query_state_codes.find_by(code: @code).blank?

    flash.now[:alert] = 'Unable to remove state code filter' unless @query.demo_query_state_codes.find_by(code: @code).delete

    render json: render_demo_query_options

    save_feasibility_total(@query)
  end
  # rubocop:enable Metrics/AbcSize
end
