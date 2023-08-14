# frozen_string_literal: true

class Employee::FinalizeProjectStatusesController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'
  before_action :load_project

  def index
    flash[:alert] = 'Unable to finalize project. Please add all required project details first.' unless @project.finishable?
  end

  def create
    if params[:finished] && @project.finishable?
      @project.surveys.each do |survey|
        survey.assign_status('finished')
        survey.save!
      end
    end

    @project.finalized!
    @project.mark_rejected_ids
    redirect_to project_close_outs_url
  end

  private

  def load_project
    @project = Project.find_by(id: params[:project_id])
  end
end
