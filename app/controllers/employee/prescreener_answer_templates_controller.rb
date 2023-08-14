# frozen_string_literal: true

class Employee::PrescreenerAnswerTemplatesController < Employee::OperationsBaseController
  authorize_resource

  before_action :set_question_template, only: [:index, :new, :create]

  def index
    @prescreener_answers = @prescreener_question.prescreener_answer_templates.order(:sort_order).page(params[:page]).per(50)
  end

  def new
    @prescreener_answer = @prescreener_question.prescreener_answer_templates.new
    @prescreener_answers = @prescreener_question.prescreener_answer_templates.page(params[:page]).per(50)
  end

  def edit
    @prescreener_answer = PrescreenerAnswerTemplate.find(params[:id])
    @prescreener_question = @prescreener_answer.prescreener_question_template
    @prescreener_answers = @prescreener_question.prescreener_answer_templates.page(params[:page]).per(50)
  end

  def create
    process_manual_entry
  rescue CSV::MalformedCSVError
    flash.now[:alert] = 'Unable to upload CSV. Please check to make sure the formatting is correct.'
    render_index
  end

  def update
    @prescreener_answer = PrescreenerAnswerTemplate.find(params[:id])
    @prescreener_question = @prescreener_answer.prescreener_question_template

    if @prescreener_answer.update(prescreener_answer_template_params)
      flash[:notice] = 'Answer successfully updated'
      redirect_to prescreener_question_answers_url(@prescreener_question)
    else
      flash[:notice] = 'Answer could not be updated'
      render 'edit'
    end
  end

  def destroy
    if params[:delete_all] == 'true'
      process_destroy_all_answers
    else
      @prescreener_answer = PrescreenerAnswerTemplate.find(params[:id])
      @prescreener_question = @prescreener_answer.prescreener_question_template
      @prescreener_answer.destroy
      redirect_to prescreener_question_answers_url(@prescreener_question)
    end
  end

  private

  def prescreener_answer_template_params
    params.require(:prescreener_answer_template).permit(:body, :target)
  end

  def set_question_template
    @prescreener_question = PrescreenerQuestionTemplate.find(params[:prescreener_question_id])
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def process_manual_entry
    @prescreener_answer = @prescreener_question.prescreener_answer_templates.new(prescreener_answer_template_params)
    if @prescreener_answer.save
      flash[:notice] = 'Prescreener answer saved successfully'
      if params[:add_another] == 'true'
        redirect_to new_prescreener_question_answer_url(@prescreener_question)
      else
        redirect_to prescreener_question_answers_url(@prescreener_question)
      end
    else
      @prescreener_answers = @prescreener_question.prescreener_answer_templates.page(params[:page]).per(50)
      render 'new'
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def process_destroy_all_answers
    @prescreener_question = PrescreenerQuestionTemplate.find(params[:prescreener_question_id])
    DestroyAllPrescreenerAnswerTemplatesJob.perform_later(@prescreener_question)
  end

  def render_index
    @prescreener_answers = @prescreener_question.prescreener_answer_templates.page(params[:page]).per(50)
    render 'index'
  end
end
