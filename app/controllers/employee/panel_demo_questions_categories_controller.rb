# frozen_string_literal: true

class Employee::PanelDemoQuestionsCategoriesController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def edit
    @demo_question = DemoQuestion.find(params[:question_id])
  end

  def update
    @demo_question = DemoQuestion.find(params[:question_id])
    @demo_questions_category = @demo_question.panel.demo_questions_categories.find_by(name: params[:demo_questions_category][:name])

    if @demo_question.update(demo_questions_category: @demo_questions_category)
      redirect_to panel_question_url(@demo_questions_category.panel, @demo_question)
    else
      render :edit
    end
  end
end
