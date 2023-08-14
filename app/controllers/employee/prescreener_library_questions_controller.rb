# frozen_string_literal: true

class Employee::PrescreenerLibraryQuestionsController < Employee::OperationsBaseController
  authorize_resource

  def index
    @prescreener_library_questions = PrescreenerLibraryQuestion.all
  end

  def new
    @prescreener_library_question = PrescreenerLibraryQuestion.new
  end

  def edit
    @prescreener_library_question = PrescreenerLibraryQuestion.find(params[:id])
  end

  def create
    @prescreener_library_question = PrescreenerLibraryQuestion.new(prescreener_library_question_params)
    @prescreener_library_question.answers = extract_answers_from_text_area

    if @prescreener_library_question.save
      flash[:notice] = 'Prescreener library question saved successfully'
      redirect_to prescreener_library_questions_url
    else
      render 'new'
    end
  end

  def update
    @prescreener_library_question = PrescreenerLibraryQuestion.find(params[:id])

    @prescreener_library_question.assign_attributes(prescreener_library_question_params)
    @prescreener_library_question.answers = extract_answers_from_text_area

    if @prescreener_library_question.save
      redirect_to prescreener_library_questions_url
    else
      render 'edit'
    end
  end

  def destroy
    @prescreener_library_question = PrescreenerLibraryQuestion.find(params[:id])
    flash[:notice] = 'Prescreener library question successfully removed' if @prescreener_library_question.destroy
    redirect_to prescreener_library_questions_url
  end

  private

  def prescreener_library_question_params
    params.require(:prescreener_library_question).permit(:question)
  end

  def extract_answers_from_text_area
    answer_text = params[:prescreener_library_question][:answers]

    answer_text.split(/\n/).map(&:strip).compact_blank.to_a
  end
end
