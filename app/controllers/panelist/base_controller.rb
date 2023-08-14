# frozen_string_literal: true

class Panelist::BaseController < ApplicationController
  skip_before_action :authenticate_employee!

  before_action :authenticate_panelist!
  before_action :set_locale

  before_action :verify_agreed_to_terms
  before_action :verify_clean_id_data_present
  before_action :verify_completed_base_demographics
  before_action :verify_demographic_questions_answered
  before_action :verify_welcomed
  before_action :verify_nonprofit_not_archived

  layout 'panelist'

  def current_user
    current_panelist
  end

  def omniauth_failure
    redirect_to new_panelist_session_url
  end

  private

  def verify_agreed_to_terms
    redirect_to accept_terms_and_conditions_url if current_panelist.agreed_to_terms_at.nil?
  end

  def verify_clean_id_data_present
    redirect_to new_clean_id_url if current_panelist.clean_id_data.blank?
  end

  def verify_completed_base_demographics
    redirect_to base_demographics_url unless current_panelist.base_demo_questions_completed?
  end

  def verify_demographic_questions_answered
    redirect_to demographics_url unless current_panelist.demos_completed?
  end

  def verify_welcomed
    redirect_to welcome_url unless current_panelist.welcomed?
  end

  def verify_nonprofit_not_archived
    return unless current_panelist.nonprofit_recently_archived?

    flash.now[:notice] =
      %(Your nonprofit has been deactivated. Please <a href="#{account_contribution_path}">choose a new nonprofit</a>.)
  end
end
