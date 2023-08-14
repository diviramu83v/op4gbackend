# frozen_string_literal: true

class Panelist::DemographicCategoriesController < Panelist::BaseController
  skip_before_action :verify_demographic_questions_answered
  skip_before_action :verify_welcomed

  before_action :verify_completed_demo_answers

  def show
    @category = current_panelist.primary_panel.demo_questions_categories.find_by(slug: params[:id])
    return redirect_back(fallback_location: panelist_dashboard_url) if @category.blank?

    @questions = current_panelist.unanswered_questions_for_category(@category)
  end

  private

  def verify_completed_demo_answers
    redirect_to panelist_dashboard_path if current_panelist.demos_completed?
  end
end
