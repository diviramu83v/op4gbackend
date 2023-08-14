# frozen_string_literal: true

class Employee::DemoQueryOnboardingsController < Employee::BaseController
  include RenderDemoQuery

  authorize_resource class: 'DemoQuery'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def create
    @query = DemoQuery.find(params[:query_id])

    @encoded_uid_list = encoded_uid_params[:encoded_uids].split(',').map(&:strip)

    successes = []
    failures = []

    @encoded_uid_list.each do |encoded_uid|
      onboarding = Onboarding.find_by(token: encoded_uid)

      begin
        if onboarding.present? && (@query.encoded_uid_onboardings << onboarding)
          successes << encoded_uid
        else
          failures << encoded_uid
        end
      rescue ActiveRecord::RecordNotUnique
        failures << encoded_uid
      end
    end

    flash[:notice] = "Successfully added #{successes.count} #{'panelist'.pluralize(successes.count)}." if successes.any?
    flash[:alert] = "Unable to add: #{failures.join(', ')}." if failures.any?

    render json: render_demo_query_traffic
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @onboarding = Onboarding.find_by(id: params[:id])

    flash.now[:alert] = 'Unable to remove encoded UID filter' unless @onboarding.present? &&
                                                                     @query.encoded_uid_onboardings.delete(@onboarding)

    render json: render_demo_query_traffic
  end

  private

  def encoded_uid_params
    params.require(:demo_query_onboardings).permit(:encoded_uids)
  end
end
