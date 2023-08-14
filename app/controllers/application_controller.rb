# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :load_ip_address
  before_action :record_request_count
  before_action :record_event
  before_action :block_if_ip_denied
  before_action :authenticate_employee!, except: [:options_request, :head_request]
  before_action :log_employee_ip
  before_action :load_or_create_device

  around_action :n_plus_one_detection unless Rails.env.production?

  rescue_from ActionController::UnknownFormat, with: :handle_unknown_format
  rescue_from ActionDispatch::RemoteIp::IpSpoofAttackError, with: :handle_spoof_attack
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_authenticity_error
  rescue_from ArgumentError, with: :handle_argument_error

  def n_plus_one_detection
    Prosopite.scan
    yield
  ensure
    Prosopite.finish
  end

  def options_request
    head :ok
  end

  def head_request
    head :ok
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session)
  end

  def current_user
    current_employee
  end
  helper_method :current_user

  def log_employee_ip
    EmployeeIpHistory.create!(employee: current_employee, ip_address: @ip) if current_employee
  end

  # Lograge method for adding extra info to logging.
  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
    payload[:request_id] = request.env['HTTP_HEROKU_REQUEST_ID']
    payload[:remote_ip] = request.remote_ip
    payload[:user] = current_user&.name
  rescue ActionDispatch::RemoteIp::IpSpoofAttackError
    # Do nothing.
  end

  private

  def load_or_create_device
    load_device
    return if @device.present?

    create_device
  end

  def load_device
    return if cookies.encrypted[:device_id].blank?

    @device = Op4gDevice.find_by(id: cookies.encrypted[:device_id])
  end

  def create_device
    @device = Op4gDevice.create!
    cookies.encrypted[:device_id] = @device.id
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def set_locale
    logger.debug "params: #{params[:locale]}"
    logger.debug "session: #{session[:locale]}"
    logger.debug "panelist: #{current_panelist.try(:locale)}"

    I18n.locale = params[:locale] ||
                  params[:country] ||
                  current_panelist.try(:locale) ||
                  session[:locale] ||
                  I18n.default_locale

    logger.debug "locale set to: #{I18n.locale}"
  rescue I18n::InvalidLocale
    I18n.locale = I18n.default_locale

    logger.debug "locale set to: #{I18n.locale}"
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def authenticate_access_to_member_data
    if authenticate_with_http_basic { |u, p| authenticate_for_member_data_access(u, p) }
      # Allow the request to proceed.
      # Maybe we should log this?
    else
      # TODO: Log this.
      request_http_basic_authentication
    end
  end

  # Check for current employee email and system password.
  # Password is currently shared by all employees.
  def authenticate_for_member_data_access(email, password)
    employee = Employee.find_by(email: email)
    return true if employee == current_employee && password == ENV.fetch('MEMBER_DATA_PASSWORD')

    false
  end

  # Verifies that a Bearer token was sent in the request, and that
  # token is also found as active in the database.
  def load_bearer_token
    @token = ApiToken.find_by(token: bearer_token)

    return token_not_found_response if @token.nil?
    return token_blocked_response if @token.blocked?
    return request.method == 'GET' && token_limited_response if @token.limited?
  end

  # Helper method for 'load_bearer_token'
  def bearer_token
    pattern = /^Bearer /
    header  = request.env['HTTP_AUTHORIZATION']
    header.gsub(pattern, '') if header&.match(pattern)
  end

  # TODO: Move this into system job? Don't want to slow down the request.
  # rubocop:disable Metrics/MethodLength
  def record_event
    description = SystemEvent.format_description(
      url: request.original_url,
      subdomain: params[:subdomain],
      controller: controller_name,
      action: action_name
    )

    load_bearer_token if request.subdomain == 'api'

    SystemEvent.create(
      # employee: current_employee,
      description: description,
      happened_at: Time.now.utc,
      api_token: @token
    )
  end
  # rubocop:enable Metrics/MethodLength

  def authenticate_admin!
    redirect_to not_found_url unless current_employee&.effective_role_admin?(@effective_role)
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :panelist
      new_panelist_session_path
    else
      new_employee_session_path
    end
  end

  def file_timestamp
    Time.now.utc.strftime('%Y-%m-%d')
  end

  # Turn the contents of a textarea into an array whose items are separated by space, commas, and newlines.
  def array_from_text_blob(text_blob)
    text_blob.split(/\s|,|[\r\n]/)
  end

  def load_ip_address
    @ip = IpAddress.find_or_create(address: request.remote_ip)
  end

  # rubocop:disable Rails/SkipsModelValidations
  def record_request_count
    @ip.increment!(:request_count)
  end
  # rubocop:enable Rails/SkipsModelValidations

  # rubocop:disable Rails/SkipsModelValidations
  def block_if_ip_denied
    return unless @ip.blocked?

    @ip.increment!(:blocked_count)

    redirect_to bad_request_url
  end
  # rubocop:enable Rails/SkipsModelValidations

  def handle_spoof_attack
    logger.info "WATCHING: Error caught: ActionDispatch::RemoteIp::IpSpoofAttackError: Client IP: #{request.client_ip}:
                 Forwarded IP: #{request.x_forwarded_for}"

    IpAddress.auto_block(address: request.client_ip.inspect, reason: 'Spoof attack')
    IpAddress.auto_block(address: request.x_forwarded_for.inspect, reason: 'Spoof attack')

    redirect_to bad_request_url
  end

  def handle_unknown_format
    redirect_to bad_request_url
  end

  def handle_authenticity_error
    load_ip_address

    logger.info "WATCHING: Error caught: ActionController::InvalidAuthenticityToken: #{request.original_url}:
                 IP: #{@ip.address}"
    @ip.record_suspicious_event!(message: 'InvalidAuthenticityToken')

    BlockInvalidAuthenticityTokenIpJob.perform_later(@ip)

    redirect_to bad_request_url
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def handle_argument_error(error)
    load_ip_address

    if error.message.start_with?('invalid byte sequence')
      logger.info "WATCHING: Error caught: ArgumentError (#{error.message}): #{request.original_url}:
                   IP: #{@ip.address}"
      @ip.record_suspicious_event!(message: 'ArgumentError: invalid byte sequence')

      redirect_to bad_request_url
    elsif error.message.start_with?('invalid %-encoding')
      logger.info "WATCHING: Error caught: ArgumentError (#{error.message}): #{request.original_url}:
                   IP: #{@ip.address}"
      @ip.record_suspicious_event!(message: 'ArgumentError: invalid encoding')

      redirect_to bad_request_url
    else
      raise "Unhandled ArgumentError type: #{error.message}"
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def token_not_found_response
    render json: { status: 400, message: 'Invalid token' }, status: :bad_request
  end

  def token_blocked_response
    render json: { status: 400, message: 'Invalid token' }, status: :bad_request
  end

  def token_limited_response
    message = <<~TEXT.tr("\n", ' ').strip
      Temporary request limit reached.
      You have called the API too many times in the past hour.
      The current limit is #{ApiToken.rate_limit_per_hour} requests per hour.
    TEXT

    render json: { status: 429, message: message }, status: :too_many_requests
  end
end
# rubocop:enable Metrics/ClassLength
