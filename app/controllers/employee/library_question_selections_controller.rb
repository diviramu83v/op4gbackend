# frozen_string_literal: true

class Employee::LibraryQuestionSelectionsController < Employee::OperationsBaseController
  authorize_resource class: 'PrescreenerLibraryQuestion'

  before_action :set_survey

  def index
    @library_question_selections = PrescreenerLibraryQuestion.all
  end

  def new
    @library_question = PrescreenerLibraryQuestion.find(params[:library_question])
    @prescreener_question = @survey.prescreener_question_templates.new
    @prescreener_question.body = @library_question.question
    @prescreener_question.answers = @library_question.answers
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @prescreener_question = @survey.prescreener_question_templates.new(prescreener_question_template_params)

    extract_answers_from_text_area.each do |answer|
      @prescreener_question.prescreener_answer_templates.new.body = answer
    end

    if prescreener_question_valid?(@prescreener_question)
      @prescreener_question.save
      @prescreener_question.reload
      flash[:notice] = 'Saved to survey, no answers are currently targeted'
      redirect_to prescreener_question_answers_url(@prescreener_question)
    else
      flash[:alert] = 'Unable to save to survey, missing required data'
      render 'new'
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def prescreener_question_template_params
    params.require(:prescreener_question_template).permit(:question_type, :passing_criteria, :body, :answers)
  end

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def extract_answers_from_text_area
    answer_text = @prescreener_question.answers

    answer_text.split(/\n/).map(&:strip).compact_blank.to_a
  end

  def prescreener_question_valid?(prescreener_question)
    prescreener_question.body.present? &&
      prescreener_question.question_type.present? &&
      prescreener_question.passing_criteria.present? &&
      prescreener_question.answers.present?
  end
end
