# frozen_string_literal: true

class Employee::CintEventsController < Employee::OperationsBaseController
  skip_authorization_check
  skip_before_action :authenticate_employee!
  protect_from_forgery with: :null_session

  def create
    return unless Base64.decode64(request.headers['X-Cint-Webhook-Secret']) == 'w7jAPCbv3R'

    event = CintEvent.new(events_data: JSON.parse(request.body.first).first)

    if event.save
      render json: { status: 200, message: 'Event saved', data: event }, status: :ok
    else
      render json: { status: 422, message: 'Event not saved', data: event.errors }, status: :unprocessable_entity
    end
  end
end
