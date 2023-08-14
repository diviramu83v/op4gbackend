# frozen_string_literal: true

class Employee::TrafficSearchesController < Employee::OperationsBaseController
  skip_authorization_check

  # rubocop:disable Metrics/AbcSize
  def create
    @survey = Survey.find(params[:survey_id])
    search_term = params[:traffic_search][:token_or_uid]
    onboarding = @survey.onboardings.find_by(uid: search_term) || @survey.onboardings.find_by(token: search_term)

    return redirect_to traffic_record_url(onboarding) if onboarding.present?

    flash[:alert] = 'Traffic record not found'
    redirect_to survey_traffic_details_url(@survey)
  end
  # rubocop:enable Metrics/AbcSize
end
