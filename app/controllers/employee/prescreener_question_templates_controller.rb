# frozen_string_literal: true

class Employee::PrescreenerQuestionTemplatesController < Employee::OperationsBaseController
  authorize_resource

  before_action :set_survey, only: [:index, :new, :create]

  def index
    @prescreener_question_templates = @survey.prescreener_question_templates.order(:sort_order).all
  end

  def new
    @prescreener_question = @survey.prescreener_question_templates.new
  end

  def edit
    @prescreener_question = PrescreenerQuestionTemplate.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  def create
    @prescreener_question = @survey.prescreener_question_templates.new(prescreener_question_template_params)
    if @prescreener_question.save
      if params[:add_answers] == 'true'
        flash[:notice] = 'Screener question saved successfully'
        redirect_to prescreener_question_answers_url(@prescreener_question)
      else
        redirect_to survey_prescreener_questions_url(@survey)
      end
    else
      render 'new'
    end
  end
  # rubocop:enable Metrics/MethodLength

  def update
    @prescreener_question = PrescreenerQuestionTemplate.find(params[:id])
    if @prescreener_question.update(prescreener_question_template_params)
      redirect_to survey_prescreener_questions_url(@prescreener_question.survey)
    else
      render 'edit'
    end
  end

  def destroy
    @prescreener_question = PrescreenerQuestionTemplate.find(params[:id])
    flash[:notice] = 'Prescreener question successfully removed' if @prescreener_question.deleted!
    redirect_to survey_prescreener_questions_url(@prescreener_question.survey)
  end

  private

  def prescreener_question_template_params
    params.require(:prescreener_question).permit(:question_type, :passing_criteria, :body)
  end

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
end
