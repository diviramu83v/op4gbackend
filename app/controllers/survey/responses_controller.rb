# frozen_string_literal: true

class Survey::ResponsesController < Survey::BaseController
  # This is a GET request, but should really be a POST in theory.
  def show
    load_parameters

    if parameters_invalid?
      log_redirect_data
      handle_invalid_parameters
    else
      @onboarding.record_survey_response(@response)
      @onboarding.record_return_key(params[:key]) if params[:key].present?
      @onboarding.add_post_survey_traffic_steps

      redirect_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
    end
  end

  def log_redirect_data
    return if @uid.blank?

    @log = RedirectLog.new
    @log.url = request.original_url
    @log.survey_response_url_id = @response.id if @response.present?
    @log.save
    return if @log.nil?
  end

  # rubocop:disable Metrics/AbcSize
  def load_parameters
    @uid = params[:uid] if params[:uid].present?
    @response = SurveyResponseUrl.find_by(token: params[:token]) if params[:token].present?
    @onboarding = Onboarding.find_by(token: params[:uid]) if params[:uid].present?
  end
  # rubocop:enable Metrics/AbcSize

  def parameters_invalid?
    @uid.blank? || @response.nil? || @onboarding.nil?
  end

  def handle_invalid_parameters
    return redirect_to survey_error_url if @uid.blank?

    return redirect_to survey_error_url if @response.nil?

    logger.info "WATCHING: IP blocking: bad response token from IP #{@ip.address}"
    redirect_to survey_error_url
  end
end
