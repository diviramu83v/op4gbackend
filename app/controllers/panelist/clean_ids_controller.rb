# frozen_string_literal: true

class Panelist::CleanIdsController < Panelist::BaseController
  skip_before_action :verify_clean_id_data_present
  skip_before_action :verify_completed_base_demographics
  skip_before_action :verify_demographic_questions_answered
  skip_before_action :verify_welcomed
  before_action :remove_cors_error_data

  def new; end

  def show
    current_panelist.update_columns(clean_id_data: clean_id_data) # rubocop:disable Rails/SkipsModelValidations
    current_panelist.suspend_based_on_clean_id if current_panelist.clean_id_failed?
  rescue JSON::ParserError
    logger.info 'WATCHING: CleanID parse error'
  ensure
    redirect_to panelist_dashboard_path
  end

  private

  # rubocop:disable Style/StringLiterals
  def remove_cors_error_data
    params[:data] = nil if params[:data] == "{\"error\":{\"message\":\"CORS Timeout.\"}}"
  end
  # rubocop:enable Style/StringLiterals

  def clean_id_data
    params[:data].present? ? JSON.parse(params[:data]) : nil
  end
end
