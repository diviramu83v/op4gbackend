class Api::V1::Employee::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  skip_before_action :record_event
  skip_before_action :block_if_ip_denied
  skip_before_action :authenticate_employee!
  skip_before_action :log_employee_ip
  skip_before_action :load_or_create_device
  skip_before_action :record_request_count

  private

  def respond_with(_resource, _opt = {})
    if current_employee
      scope ||= Devise::Mapping.find_scope!(current_employee)
      aud ||= headers[Warden::JWTAuth.config.aud_header]
      token, payload = Warden::JWTAuth::UserEncoder.new.call(
        current_employee, scope, aud
      )
      current_employee.on_jwt_dispatch(token, payload) if current_employee.respond_to?(:on_jwt_dispatch)
      Warden::JWTAuth::HeaderParser.to_headers(headers, token)
      @request
      response.headers['Authorization'] = token

      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: current_employee,
        message: "You are logged in."
      ), status: :ok
    else
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 401,
        payload: {},
        message: "Unauthorized!"
      ), status: :unauthorized
    end
  end

  def respond_to_on_destroy
    log_out_success && return if current_employee

    log_out_failure
  end

  def log_out_success
    render json: ResponseFormatRepresenter.new(
      success: true,
      code: 200,
      payload: {},
      message: "You are logged out."
    ), status: :ok
  end

  def log_out_failure
    render json: ResponseFormatRepresenter.new(
      success: false,
      code: 401,
      payload: {},
      message: "Log out failed, hmm nothing happened."
    ), status: :unauthorized
  end
end