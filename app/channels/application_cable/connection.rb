# frozen_string_literal: true

# Base class for action cable connections.
# TODO: Add a unique ID.
class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user

  def connect
    Rails.logger.debug 'ApplicationCable::Connection#connect'
    self.current_user = find_verified_user
  end

  private

  def find_verified_user
    if (current_user = Employee.find_by(id: cookies.encrypted['_my_app_session']['warden.user.employee.key']&.flatten&.first))
      current_user
    else
      reject_unauthorized_connection
    end
  end
end
