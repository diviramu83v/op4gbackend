# frozen_string_literal: true

class Api::BaseAllowExternalController < Api::BaseController
  skip_before_action :record_event
  skip_before_action :log_employee_ip
  skip_before_action :load_or_create_device
  skip_before_action :record_request_count
end
