# frozen_string_literal: true

class Employee::DemoQueryAgeRangesController < Employee::OperationsBaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def create
    @query = DemoQuery.find(params[:query_id])
    @questions = @query.questions
    @from = params[:from]
    @to = params[:to]

    alert = "Unable to add age filter. \"To\" age needs to be #{Age.max_age} or less." if @to.blank? || @to.to_i > Age.max_age
    alert = "Unable to add age filter. \"From\" age needs to be #{Age.min_age} or greater." if @from.blank? || @from.to_i < Age.min_age
    return redirect_to query_url(@query), alert: alert if alert.present?

    if @from.present? && @to.present?
      (@from.to_i..@to.to_i).each do |age|
        age_to_add = Age.find_by(value: age)
        @query.ages << age_to_add unless @query.ages.include?(age_to_add)
      rescue ActiveRecord::RecordNotUnique
        next
      end
    end

    render json: render_demo_query_options

    save_feasibility_total(@query)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
