# frozen_string_literal: true

class Panelist::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :facebook

  # rubocop:disable Metrics/MethodLength
  def facebook
    unless FeatureManager.panelist_facebook_auth?
      redirect_to new_panelist_session_url
      return
    end

    params = facebook_params

    email = params.dig(:info, :email)
    if email.nil?
      oauth_server_error_alert(:facebook)

      return redirect_to new_panelist_session_url
    end

    panelist = Panelist.find_by(email: email)
    if panelist.nil?
      panelist = create_panelist_from_facebook_info(params)
    else
      add_facebook_info_for_existing_panelist(panelist, params)
    end

    sign_in_and_redirect panelist
  end

  # rubocop:disable Metrics/AbcSize
  def paypal_oauth2
    return redirect_to new_panelist_session_url unless FeatureManager.panelist_paypal_verification?

    email = paypal_params[:email]
    verified_account = paypal_params[:verified_account]

    return redirect_to panelist_dashboard_url if missing_paypal_info?(email, verified_account)

    panelist_email = get_panelist(request.env['omniauth.params']['panelist_email'])

    return redirect_to panelist_dashboard_url if panelist_email.nil?

    update_panelist_paypal(panelist_email, email, verified_account)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_panelist_from_facebook_info(params)
    panel = Panel.find_by(slug: 'op4g-us')

    full_name = params.dig(:info, :name)
    oauth_server_error_alert(:facebook) if full_name.nil?

    names = full_name.split
    now = Time.now.utc

    panelist = Panelist.new(
      original_panel: panel,
      primary_panel: panel,
      email: params.info.email,
      confirmed_at: now,
      first_name: names[0],
      last_name: names[1],
      facebook_authorized: now,
      facebook_image: params.info.image,
      provider: params.provider,
      facebook_uid: params.uid
    )

    panelist.save(validate: false)
    panelist.reload

    panelist
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def add_facebook_info_for_existing_panelist(panelist, params)
    facebook_authorized = panelist.facebook_authorized || Time.now.utc
    facebook_uid = panelist.facebook_uid || params.uid
    provider = panelist.provider || params.provider

    panelist.update!(
      facebook_authorized: facebook_authorized,
      facebook_image: params.info.image,
      provider: provider,
      facebook_uid: facebook_uid
    )
  end

  def missing_paypal_info?(email, verified_account)
    return false if email.present? && !verified_account.nil?

    oauth_server_error_alert(:paypal)

    true
  end

  def get_panelist(email)
    panelist = Panelist.find_by(email: email)

    oauth_server_error_alert(:paypal) if panelist.nil?

    panelist
  end

  def update_panelist_paypal(panelist, email, verified_account)
    if verified_account == true
      panelist.update!(paypal_verification_status: 'verified', email: email)

      flash[:notice] = 'Success! Your Paypal account is now verified with Op4G.'
    else
      flash[:notice] = 'Your Paypal account is not yet verified; please verify your account at www.paypal.com and try again.'
    end

    redirect_to panelist_dashboard_url
  end

  def facebook_params
    params = request.env.fetch('omniauth.auth').slice(:info, :provider, :uid)

    params.info = params.info.slice(:email, :image, :name) if params&.info

    params
  end

  def paypal_params
    params = request.env.fetch('omniauth.auth').slice(:extra, :info, :provider, :uid)

    params.info = params.info.slice(:email, :name) if params&.info
    params.extra = params.extra.slice(:verified_account) if params&.extra

    { email: params.dig(:info, :email),
      verified_account: params.dig(:extra, :verified_account) }
  end

  def oauth_server_error_alert(provider)
    flash[:alert] = "Error while communicating with the #{provider.to_s.capitalize} server; please contact support."
  end
end
