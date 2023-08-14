# frozen_string_literal: true

class Employee::PanelDemoOptionsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def new
    @demo_question = DemoQuestion.find(params[:question_id])
    @demo_option = @demo_question.demo_options.new
  end

  def edit
    @demo_option = DemoOption.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @demo_question = DemoQuestion.find(params[:question_id])
    @demo_option = @demo_question.demo_options.new(demo_options_params)
    if @demo_option.save
      if params[:add_another] == 'true'
        flash[:notice] = 'Demo option successfully added'
        redirect_to new_panel_question_option_url(@demo_question.panel, @demo_question)
      else
        redirect_to panel_question_url(@demo_question.panel, @demo_question)
      end
    else
      render :new
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def update
    @demo_option = DemoOption.find(params[:id])
    if @demo_option.update(demo_options_params)
      if params[:add_another] == 'true'
        flash[:notice] = 'Demo option successfully added'
        redirect_to new_panel_question_option_url(@demo_option.panel, @demo_option.demo_question)
      else
        redirect_to panel_question_url(@demo_option.panel, @demo_option.demo_question)
      end
    else
      render :edit
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def demo_options_params
    params.require(:demo_option).permit(:label, :sort_order)
  end
end
