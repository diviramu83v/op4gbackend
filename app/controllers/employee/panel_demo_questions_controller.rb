# frozen_string_literal: true

class Employee::PanelDemoQuestionsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'
  before_action :set_demo_question, only: [:show, :edit, :update]
  before_action :set_panel, only: [:index, :new, :create]

  def index; end

  def show; end

  def new
    @demo_question = @panel.demo_questions.new
  end

  def edit; end

  def create
    @demo_question = DemoQuestion.new(demo_question_params)
    if @demo_question.save
      redirect_to panel_question_url(@demo_question.panel, @demo_question)
    else
      render :new
    end
  end

  def update
    if @demo_question.update(demo_question_params)
      redirect_to panel_question_url(@demo_question.panel, @demo_question)
    else
      render :edit
    end
  end

  private

  def demo_question_params
    params.require(:demo_question).permit(:input_type, :body, :label, :sort_order, :demo_questions_category_id)
  end

  def set_demo_question
    @demo_question = DemoQuestion.find(params[:id])
  end

  def set_panel
    @panel = Panel.find(params[:panel_id])
  end
end
