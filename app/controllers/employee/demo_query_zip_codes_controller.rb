# frozen_string_literal: true

class Employee::DemoQueryZipCodesController < Employee::OperationsBaseController
  include RenderDemoQuery
  include SetFeasibilityTotal

  authorize_resource class: 'DemoQuery'

  def index
    @query = DemoQuery.find(params[:query_id])
    @count = @query.panelist_count
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def create
    @query = DemoQuery.find(params[:query_id])

    @zip_list = demo_query_zip_params[:zips].split(/\n/).map(&:strip)

    successes = []
    failures = []

    @zip_list.first(1000).each do |code|
      zip = ZipCode.find_by(code: code)

      begin
        if zip.present? && (@query.zip_codes << zip)
          successes << code
        else
          failures << code
        end
      rescue ActiveRecord::RecordNotUnique
        failures << code
      end
    end

    flash[:notice] = "Successfully added #{successes.count} #{'ZIP code'.pluralize(successes.count)}." if successes.any?
    flash[:alert] = "Unable to add: #{failures.count}. #{'ZIP code'.pluralize(failures.count)}." if failures.any?
    flash[:alert] = 'Only the first 1000 zip codes were uploaded.' if @zip_list.count > 1000

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @zip = ZipCode.find_by(id: params[:id])

    @query.zip_codes.delete @zip if @zip.present?

    render json: render_demo_query_zip_codes

    save_feasibility_total(@query)
  end

  private

  def demo_query_zip_params
    params.require(:demo_query_zip).permit(:zips)
  end
end
