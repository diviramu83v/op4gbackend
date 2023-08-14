# frozen_string_literal: true

class Employee::CompleteMilestonesController < Employee::OperationsBaseController
  skip_authorization_check

  def index
    @survey = Survey.find(params[:survey_id])
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @milestone = @survey.complete_milestones.new(milestone_params)
    if @milestone.save
      render 'create', locals: { milestone_target: milestone_params[:target_completes], survey_id: @survey.id }
    else
      render 'error', locals: { error_message: @milestone.errors[:base].first, survey_id: @survey.id }
    end
  end

  private

  def milestone_params
    params.require(:complete_milestone).permit(:target_completes)
  end
end
