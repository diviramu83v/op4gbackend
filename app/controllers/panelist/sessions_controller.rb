# frozen_string_literal: true

class Panelist::SessionsController < Devise::SessionsController
  layout 'panelist'

  append_before_action :set_locale
  append_before_action :set_session_locale
  after_action :set_locale
  after_action :set_session_locale

  after_action :record_activity, only: [:create]
  after_action :create_ip_history, only: [:create]

  def new
    @pixels = TrackingPixel.confirmation
    super
  end

  def create
    return redirect_to initial_signup_url(current_panelist) if expert_panelist_is_not_approved?

    super
  end

  private

  def set_session_locale
    session[:locale] = params[:locale] || params[:country] || current_panelist.try(:locale) || session[:locale] || I18n.locale
  end

  def record_activity
    current_panelist&.record_activity
  end

  def create_ip_history
    current_panelist&.record_signin_ip(@ip)
  end

  def expert_panelist_is_not_approved?
    current_panelist&.premium? && !current_panelist.approved?
  end
end
