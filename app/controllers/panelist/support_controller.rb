# frozen_string_literal: true

class Panelist::SupportController < Panelist::BaseController
  skip_before_action :verify_agreed_to_terms
  skip_before_action :verify_completed_base_demographics
  skip_before_action :verify_demographic_questions_answered

  def show; end
end
