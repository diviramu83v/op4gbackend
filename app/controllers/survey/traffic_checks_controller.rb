# frozen_string_literal: true

class StepAlreadyCompleted < StandardError; end

# rubocop:disable Metrics/ClassLength
class Survey::TrafficChecksController < Survey::BaseController
  before_action :load_step_and_onboarding
  before_action :set_response_token
  before_action :check_request_format
  before_action :check_if_step_is_already_completed, only: [:new, :show, :create]
  rescue_from StepAlreadyCompleted, with: :handle_already_started_error

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
  def new
    @traffic_step.create_traffic_check_event('new', @ip)

    case @traffic_step.category
    when 'clean_id'
      load_clean_id
    when 'recaptcha'
      render 'recaptcha'
    when 'prescreener'
      load_prescreener
    when 'gate_survey'
      load_gate_survey
    when 'pre_analyze'
      pre_analyze
    when 'post_analyze'
      post_analyze
    when 'follow_up'
      load_follow_up
    when 'expert_follow_up'
      load_expert_follow_up
    when 'redirect'
      final_redirect
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

  def show
    case @traffic_step.category
    when 'clean_id'
      process_clean_id
    end
  end

  def create # rubocop:disable
    case @traffic_step.category
    when 'recaptcha'
      process_recaptcha
    when 'gate_survey'
      process_gate_survey
    when 'follow_up'
      process_follow_up
    when 'expert_follow_up'
      process_expert_follow_up
    end
  end

  private

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def url_calculator
    @final_url ||= FinalUrlRedirect.new(onboarding: @onboarding)
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def final_redirect
    @traffic_step.complete_step

    @onboarding.record_cint_response

    TrafficEvent.create!(
      onboarding: @onboarding,
      category: 'info',
      message: 'redirected to final URL',
      url: url_calculator.final_url
    )

    redirect_to url_calculator.final_url
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def pre_analyze
    @traffic_step.complete_step

    if analyzer.failed_prescreener?
      record_screener_failure

      return redirect_to route_failed_screened_traffic
    end

    if analyzer.failed_pre_survey?
      record_pre_survey_failure
      return redirect_to url_calculator.failed_traffic_steps_url
    end

    survey_url_redirect = survey_url_with_token

    if survey_url_redirect.present?
      record_sent_to_client_survey(survey_url_redirect)
      redirect_to survey_url_redirect
    else
      redirect_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze&.token)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def post_analyze
    return redirect_to url_calculator.failed_traffic_steps_url if @traffic_step.complete?

    @traffic_step.complete_step

    if analyzer.failed_post_survey?
      record_post_survey_failure
      record_failed_analyze_step
      redirect_to url_calculator.failed_traffic_steps_url
    elsif analyzer.flagged_post_survey?
      record_post_survey_flagging
      redirect_to next_step_url
    else
      record_passed_second_analyze_step
      redirect_to next_step_url
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def load_clean_id
    render 'clean_id', locals: {
      traffic_step: @traffic_step,
      onboarding: @onboarding
    }
  end

  def load_prescreener
    @traffic_step.complete_step
    if @onboarding.next_prescreener_question&.token.present?
      redirect_to new_survey_screener_step_question_url(@onboarding.next_prescreener_question&.token)
    else
      redirect_to next_step_url
    end
  end

  def load_gate_survey
    @gate_survey = GateSurvey.new
    render 'gate_survey'
  end

  def load_follow_up
    render 'follow_up'
  end

  def load_expert_follow_up
    render 'expert_follow_up'
  end

  def process_clean_id
    remove_cors_error_data
    data = params[:data].present? && json_valid? ? JSON.parse(params[:data]) : nil
    @traffic_step.create_traffic_check_event('show', @ip, data_collected: data)
    @traffic_step.complete_step
    redirect_to next_step_url
  end

  def process_recaptcha
    @traffic_step.create_traffic_check_event('create', @ip, data_collected: collect_recaptcha_data)
    @traffic_step.complete_step
    redirect_to next_step_url
  end

  def process_gate_survey
    @traffic_step.create_traffic_check_event('create', @ip, data_collected: gate_survey_params)
    @gate_survey = GateSurvey.new(gate_survey_params.merge(onboarding: @onboarding))
    @gate_survey.save
    @traffic_step.complete_step
    redirect_to next_step_url
  rescue ActiveModel::RangeError
    Rails.logger.info('Bad gate data: we don\'t care')
  end

  def process_follow_up
    email = params.dig(:step, :email)
    @traffic_step.create_traffic_check_event('create', @ip, data_collected: { email: email })
    @onboarding.update!(email: email)
    @traffic_step.complete_step
    redirect_to next_step_url
  end

  def next_step_url
    next_step_token = @onboarding.next_traffic_step_or_analyze&.token
    new_survey_step_check_url(next_step_token)
  end

  def survey_url_with_token
    url = @onboarding.survey_url_with_parameters

    # Substitute test URL sometimes.
    url = test_url if current_employee.present? && @onboarding.draft? && url.blank?
    url = test_url if current_employee&.survey_test_mode&.easy_mode?

    url
  end

  def gate_survey_params
    params.require(:step).permit(:state, :zip, :birthdate, :age, :gender, :income, :ethnicity)
  end

  def route_failed_screened_traffic
    return url_calculator.final_url if @onboarding.onramp.schlesinger?
    return screened_url if @onboarding.panel.present?
    return vendor_term_url if @onboarding.vendor.present?

    screened_url
  end

  def collect_recaptcha_data
    stored_data = {}
    # stored_data[:token_already_used] = @onboarding.recaptcha_passed? # revist later
    recaptcha = Recaptcha.new(request, ENV.fetch('RECAPTCHA_SECRET_KEY_TRAFFIC', nil))
    stored_data[:recaptcha_token_valid] = !recaptcha.token_invalid?(params['g-recaptcha-response'])
    stored_data
  end

  def test_url
    test_survey_url(@onboarding.survey.token, uid: @onboarding.token)
  end

  def screened_url
    survey_screened_url(token: @onboarding.response_token)
  end

  def test_mode_on?
    return false if current_employee.nil?

    current_employee.test_mode_on?
  end

  def analyzer
    @analyzer ||= TrafficAnalyzer.new(onboarding: @onboarding, test_mode: test_mode_on?, request: request)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def vendor_term_url
    if @onboarding.vendor_batch&.terminate_url.present? || @onboarding.vendor&.terminate_url.present?
      url = (@onboarding.vendor_batch&.terminate_url || @onboarding.vendor&.terminate_url) + @onboarding.uid
      UrlHasher.new(url: url, vendor: @onboarding.vendor).url_hashed_if_needed
    else
      survey_screened_url(token: @onboarding.response_token)
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def load_step_and_onboarding
    @traffic_step = TrafficStep.find_by(token: params[:step_token])
    return redirect_to not_found_url if @traffic_step.nil?

    @onboarding = @traffic_step.onboarding
    redirect_to not_found_url if @onboarding.nil?
  end

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def set_response_token
    @response_token ||= params[:response_token]
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  # rubocop:disable Style/StringLiterals
  def remove_cors_error_data
    params[:data] = nil if params[:data] == "{\"error\":{\"message\":\"CORS Timeout.\"}}"
  end
  # rubocop:enable Style/StringLiterals

  # rubocop:disable Metrics/MethodLength
  def record_sent_to_client_survey(url)
    TrafficEvent.create!(
      onboarding: @onboarding,
      category: 'info',
      message: 'redirected to client survey',
      url: url
    )

    @onboarding.record_onboarding_completion

    logger.info <<~LOG
      Traffic record sent to survey:
      URL:#{url}
      Original UID:#{@onboarding.uid}
      Client UID:#{@onboarding.token}
      IP:#{@onboarding.ip_address.address}
    LOG

  end
  # rubocop:enable Metrics/MethodLength

  def record_screener_failure
    @onboarding.call_vendor_webhook
    @onboarding.record_cint_response
    @onboarding.onramp.update(has_prescreener_failures: true) unless @onboarding.onramp.has_prescreener_failures?
    TrafficEvent.create(
      onboarding: @onboarding,
      category: 'fraud',
      message: "#{@traffic_step.category}: #{analyzer.failed_reason}",
      url: route_failed_screened_traffic
    )
  end

  def record_pre_survey_failure
    @onboarding.add_error(analyzer.failed_reason.to_s)
    @onboarding.record_cint_response
    TrafficEvent.create(
      onboarding: @onboarding,
      category: 'fraud',
      message: "#{@traffic_step.category}: #{analyzer.failed_reason}",
      url: url_calculator.failed_traffic_steps_url
    )
  end

  def record_post_survey_failure
    @onboarding.mark_failed_post_survey(analyzer.failed_reason.to_s)
    @onboarding.record_cint_response
    remove_complete_response
    TrafficEvent.create(
      onboarding: @onboarding,
      category: 'fraud',
      message: "#{@traffic_step.category}: #{analyzer.failed_reason}",
      url: url_calculator.failed_traffic_steps_url
    )
  end

  def record_post_survey_flagging
    @onboarding.mark_flagged_post_survey("failed: #{analyzer.failed_reason}")
    TrafficEvent.create(
      onboarding: @onboarding,
      category: 'fraud',
      message: "#{@traffic_step.category}: #{analyzer.failed_reason}",
      url: next_step_url
    )
  end

  def record_failed_analyze_step
    TrafficEvent.create!(
      onboarding: @onboarding,
      category: 'info',
      message: 'post_analyze: failed'
    )
  end

  def record_passed_second_analyze_step
    TrafficEvent.create!(
      onboarding: @onboarding,
      category: 'info',
      message: 'analyze: passed'
    )
  end

  def remove_complete_response
    @onboarding.update!(survey_response_url: nil)
  end

  def check_request_format
    respond_to do |format|
      format.html { return }
      format.all { redirect_to not_found_url }
    end
  end

  def check_if_step_is_already_completed
    return unless @traffic_step.complete?

    raise StepAlreadyCompleted
  end

  def handle_already_started_error
    redirect_to url_calculator.failed_traffic_steps_url
  end
end
# rubocop:enable Metrics/ClassLength

def json_valid?
  return true if JSON.parse(params[:data])
rescue JSON::ParserError
  false
end
