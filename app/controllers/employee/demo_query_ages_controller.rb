# frozen_string_literal: true

class Employee::DemoQueryAgesController < Employee::OperationsBaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  # rubocop:disable Metrics/AbcSize
  def create
    @query = DemoQuery.find(params[:query_id])
    @age = Age.find_by(id: params[:age_id])

    begin
      successful_update = @age.present? && (@query.ages << @age)
      flash.now[:alert] = 'Unable to add age filter.' unless successful_update

      render json: render_demo_query_options
    rescue ActiveRecord::RecordNotUnique
      render json: render_demo_query_options
    end

    save_feasibility_total(@query)
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @age = Age.find_by(id: params[:id])

    successful_update = @age.present? && @query.ages.delete(@age)
    flash.now[:alert] = 'Unable to remove age filter.' unless successful_update

    render json: render_demo_query_options

    save_feasibility_total(@query)
  end
end
