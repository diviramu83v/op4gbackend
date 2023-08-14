# frozen_string_literal: true

class Employee::DemoQueryFiltersController < Employee::OperationsBaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def destroy
    @query = DemoQuery.find(params[:query_id])
    @query.update!(country: nil)
    @query.options.destroy_all
    @query.demo_query_state_codes.destroy_all
    @query.ages.destroy_all
    @query.regions.destroy_all
    @query.divisions.destroy_all
    @query.states.destroy_all
    @query.dmas.destroy_all
    @query.msas.destroy_all
    @query.pmsas.destroy_all
    @query.counties.destroy_all
    @query.zip_codes.destroy_all
    @query.project_inclusions.destroy_all
    @query.encoded_uid_onboardings.destroy_all

    case params[:source]
    when 'demo_query_options'
      render json: render_demo_query_options
    when 'demo_query_zip_codes'
      render json: render_demo_query_zip_codes
    else # params[:format] == 'demo_query_traffic'
      render json: render_demo_query_traffic
    end

    save_feasibility_total(@query)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
