# frozen_string_literal: true

class Employee::DemoQueriesController < Employee::OperationsBaseController
  include RenderDemoQuery

  authorize_resource

  def index
    @survey = Survey.find(params[:survey_id])
  end

  def new
    @panels = Panel.active.sort_by(&:active_panelist_count).reverse
    @survey = Survey.find(params[:survey_id]) if params[:survey_id]
  end

  # rubocop:disable Metrics/MethodLength
  def create
    if params[:survey_id]
      @survey = Survey.find(params[:survey_id])
      @query = @survey.queries.new(query_params)
    else
      @query = DemoQuery.new(query_params)
    end

    if @query.save
      redirect_to query_url(@query)
    else
      # Redirecting here instead of _render 'new'_. Seems cleaner than
      # reloading the @panels variable and rendering again. Seems unlikely that
      # we'll need to show an error message or anything in the case that the
      # panel is invalid.
      redirect_to new_query_url
    end
  end
  # rubocop:enable Metrics/MethodLength

  # TODO: this should probably be edit instead of show
  def show
    @query = DemoQuery.find(params[:id])
    @count = @query.panelist_count
    @question_panelist_count = question_panelist_count(@query).rows
    return if @query.editable?

    redirect_to survey_queries_url(@query.survey),
                alert: 'Unable to edit a query with sample batches.
                        Please remove all sample batches first or use a new query.'
  end

  def destroy
    @query = DemoQuery.find(params[:id])

    if @query.removable?
      @query.destroy
    else
      flash[:alert] =
        "Unable to remove query. Please remove sample #{'batch'.pluralize(@query.sample_batches.count)} first."
    end

    redirect_to survey_queries_url(@query.survey)
  end

  private

  def query_params
    params.permit(:panel_id)
  end
end
