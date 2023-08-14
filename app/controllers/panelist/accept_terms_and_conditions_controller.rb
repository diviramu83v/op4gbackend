# frozen_string_literal: true

class Panelist::AcceptTermsAndConditionsController < Panelist::BaseController
  skip_before_action :verify_agreed_to_terms
  skip_before_action :verify_clean_id_data_present
  skip_before_action :verify_completed_base_demographics
  skip_before_action :verify_demographic_questions_answered
  skip_before_action :verify_welcomed

  def show; end

  def create
    current_panelist.update!(agreed_to_terms_at: Time.now.utc)

    redirect_to panelist_dashboard_url
  end
end
