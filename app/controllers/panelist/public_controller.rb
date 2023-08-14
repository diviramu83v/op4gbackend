# frozen_string_literal: true

class Panelist::PublicController < ApplicationController
  skip_before_action :authenticate_employee!
  before_action :set_locale

  layout 'panelist'

  def current_user
    current_panelist.presence
  end

  private

  def redirect_to_dashboard_if_signed_in
    redirect_to panelist_dashboard_url if current_panelist.present?
  end
end
