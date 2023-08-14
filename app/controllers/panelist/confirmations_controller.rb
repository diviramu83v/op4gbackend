# frozen_string_literal: true

class Panelist::ConfirmationsController < Devise::ConfirmationsController
  layout 'panelist'

  protected

  # rubocop:disable Metrics/AbcSize
  def after_confirmation_path_for(_resource_name, resource)
    sign_in(resource)

    SignupReminder.create!(panelist: current_panelist, status: SignupReminder.statuses[:waiting], send_at: Time.now.utc + 1.day)
    SignupReminder.create!(panelist: current_panelist, status: SignupReminder.statuses[:waiting], send_at: Time.now.utc + 3.days)

    panelist_dashboard_url(country: params[:country], locale: params[:locale])
  end
  # rubocop:enable Metrics/AbcSize
end
