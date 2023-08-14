# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Panelist::RegistrationsController < Devise::RegistrationsController
  include LandingPageParameterHandling

  layout 'panelist'

  before_action :configure_permitted_parameters
  before_action :set_locale

  def new
    store_landing_parameters
    super # use standard Devise login for now
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    build_resource(sign_up_params)

    resource.assign_attributes(
      campaign: session_campaign_or_nothing,
      lock_flag: campaign_lock_flag_or_nothing,
      locale: session_locale_or_default,
      nonprofit: session_nonprofit_or_nothing,
      original_nonprofit: session_nonprofit_or_nothing,
      original_panel: session_panel_or_default,
      primary_panel: session_panel_or_default,
      last_activity_at: Time.now.utc
    )

    recaptcha = Recaptcha.new(request, ENV.fetch('RECAPTCHA_SECRET_KEY_REGISTRATION', nil))

    if recaptcha.token_valid?(params['g-recaptcha-response'])
      begin
        if source_present? && resource.save
          PanelistIpHistory.create!(source: 'signup', panelist: resource, ip_address: @ip)
          record_session_variables
          clear_session_variables

          set_flash_message! :notice, :signed_up_but_unconfirmed
          # sign_up(resource_name, resource)

          respond_with resource, location: after_sign_up_path_for(resource)
        else
          clean_up_passwords resource
          set_minimum_password_length
          flash[:alert] = 'Unable to complete sign up.'
          respond_with resource
        end
      rescue Net::SMTPAuthenticationError
        redirect_to new_panelist_registration_path, notice: 'Email service momentarily unavailable; please try again.'
      end
    else
      flash[:alert] = 'Please complete the captcha.'
      render 'new'
    end
  rescue Net::OpenTimeout => e
    logger.info "WATCHING: Error caught: #{e.message}"
    redirect_to new_panelist_registration_path, alert: 'Something unexpected happened. Please try again.'
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  protected

  # Devise customization
  def after_sign_up_path_for(_resource)
    new_panelist_session_url(country: params[:country], locale: params[:locale], emailed: true)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

  # rubocop:disable Metrics/AbcSize
  def source_present?
    return false unless session[:code].present? || session[:aff_id].present?

    campaign = RecruitingCampaign.find_by(code: session[:code]) if session[:code]
    affiliate = Affiliate.find_by(code: session[:aff_id]) if session[:aff_id]

    campaign.present? || affiliate.present?
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def record_session_variables
    resource.offer_code = session[:offer_id] if resource.offer_code.blank?
    resource.affiliate_code = session[:aff_id] if resource.affiliate_code.blank?
    resource.sub_affiliate_code = session[:aff_sub] if resource.sub_affiliate_code.blank?
    resource.sub_affiliate_code_2 = session[:aff_sub2] if resource.sub_affiliate_code_2.blank?

    resource.save

    resource.panels << resource.original_panel
  end
  # rubocop:enable Metrics/AbcSize

  def session_nonprofit_or_nothing
    Nonprofit.find_by(id: session[:nonprofit_id]) if session[:nonprofit_id].present?
  end

  def session_panel_or_default
    panel_slug = session[:panel].try(:downcase)

    if panel_slug.present?
      Panel.find_by(slug: panel_slug) || Panel.default
    else
      Panel.default
    end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
  def session_locale_or_default
    if session[:locale].present?
      locale = session[:locale].downcase
      return locale if Locale::SLUGS.include?(locale)
    end

    if session[:country].present?
      country = session[:country].downcase
      return case country
             when 'us', 'ca', 'uk', 'au'
               'en'
             when 'de'
               'de'
             when 'fr'
               'fr'
             when 'it'
               'it'
             when 'es'
               'es'
             end
    end

    Locale.default
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

  def session_campaign_or_nothing
    RecruitingCampaign.find_by(code: session[:code]) if session[:code].present?
  end

  def campaign_lock_flag_or_nothing
    session_campaign_or_nothing.lock_flag if session_campaign_or_nothing.present?
  end

  # rubocop:disable Metrics/AbcSize
  def clear_session_variables
    session.delete(:nonprofit_id)
    session.delete(:country)
    session.delete(:locale)
    session.delete(:code)
    session.delete(:panel)
    session.delete(:offer_id)
    session.delete(:aff_id)
    session.delete(:aff_sub)
    session.delete(:aff_sub2)
  end
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ClassLength
