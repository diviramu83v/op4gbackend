# frozen_string_literal: true

class Employee::DemoAnswersController < Employee::MembershipBaseController
  authorize_resource class: 'Panelist'

  def edit
    @demo_answer = DemoAnswer.find(params[:id])
  end

  def update
    @demo_answer = DemoAnswer.find(params[:id])
    if @demo_answer.update(demo_option_id: new_demo_option)
      redirect_to edit_panelist_url(@demo_answer.panelist)
    else
      render 'edit'
    end
  end

  private

  def new_demo_option
    params.dig(:demo_answer, :demo_option)&.to_i
  end
end
