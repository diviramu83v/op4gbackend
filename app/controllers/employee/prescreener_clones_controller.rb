# frozen_string_literal: true

class Employee::PrescreenerClonesController < Employee::OperationsBaseController
  authorize_resource class: 'PrescreenerQuestionTemplate'
  before_action :load_survey

  def show # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    @search_terms = params.dig('prescreener_clone_search', 'id_or_keyword')&.split(' ')&.map(&:strip)

    if @search_terms.present?
      project = Project.find_by(id: @search_terms)

      @surveys_with_prescreener_questions = project.surveys.with_active_prescreener_questions if project.present?

      return @surveys_with_prescreener_questions if @surveys_with_prescreener_questions.present?

      question_collections = @search_terms.map do |keyword| # array of collections of questions
        PrescreenerQuestionTemplate.active.search_by_keyword(keyword.downcase)
      end

      # convert each set of questions to a unique set of surveys
      survey_collections = question_collections.map do |collection|
        collection.map(&:survey).uniq
      end

      # combine all sets of surveys into a single set
      surveys = survey_collections.flatten!

      # group / count and sort by the survey id
      @surveys_with_prescreener_questions = surveys.tally.sort_by { |_k, v| v }.reverse.map(&:first)

      if @surveys_with_prescreener_questions.empty?
        flash[:alert] = "Prescreener(s) not found for project id or keyword(s): #{@search_terms.join(' ')}"
        redirect_to survey_prescreener_clones_url
      end
    else
      @surveys_with_prescreener_questions = Survey.with_active_prescreener_questions.order(created_at: :desc).page(params[:page]).per(50)
    end
  end

  def create
    survey_to_clone = Survey.find(params[:survey_to_clone])
    survey_to_clone.clone_prescreener(@survey)

    redirect_to survey_prescreener_questions_url(@survey)
  end

  private

  def load_survey
    @survey = Survey.find(params[:survey_id])
  end
end
