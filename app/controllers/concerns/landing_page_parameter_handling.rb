# frozen_string_literal: true

module LandingPageParameterHandling
  include ActiveSupport::Concern

  private

  # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def store_landing_parameters
    session[:panel] = params[:panel] if params[:panel].present?
    session[:code] = params[:code] if params[:code].present?
    session[:country] = params[:country] if params[:country].present?

    session[:locale] = params[:locale] || params[:country] || session[:locale] || I18n.default_locale

    session[:offer_id] = params[:offer_id] if params[:offer_id].present?
    session[:aff_id] = params[:aff_id] if params[:aff_id].present?
    session[:aff_sub] = params[:aff_sub] if params[:aff_sub].present?
    session[:aff_sub2] = params[:aff_sub2] if params[:aff_sub2].present?
  end
  # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
