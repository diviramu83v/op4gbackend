# frozen_string_literal: true

class Employee::DemoQueryOptionsController < Employee::BaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  # rubocop:disable Metrics/AbcSize
  def create
    @query = DemoQuery.find(params[:query_id])
    @option = DemoOption.find_by(id: params[:option_id])
    @question_panelist_count = question_panelist_count(@query).rows

    flash.now[:alert] = 'Unable to add option filter.' unless @option.present? && (@query.options << @option)

    render json: render_demo_query_options

    save_feasibility_total(@query)
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def destroy
    @query = DemoQuery.find(params[:query_id])
    @option = DemoOption.find_by(id: params[:id])
    @question_panelist_count = question_panelist_count(@query).rows

    flash.now[:alert] = 'Unable to remove option filter.' unless @option.present? && @query.options.delete(@option)

    render json: render_demo_query_options

    save_feasibility_total(@query)
  end
  # rubocop:enable Metrics/AbcSize
end
