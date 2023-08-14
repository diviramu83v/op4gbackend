# frozen_string_literal: true

class Panelist::LocalesController < Panelist::PublicController
  def create
    if locale_params[:locale].present?
      locale = locale_params[:locale].downcase
      session[:locale] = locale if Locale::SLUGS.include?(locale)
    end

    redirect_back fallback_location: landing_page_url
  end

  private

  def locale_params
    params.require(:settings).permit(:locale)
  end
end
