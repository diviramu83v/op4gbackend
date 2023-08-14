# frozen_string_literal: true

class Employee::PanelistEarningsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'
  before_action :load_project

  def index
    @onboardings = @project.accepted_panelist_onboardings
  end

  def create
    @project.create_earnings_for_accepted_panelists

    redirect_to project_close_out_url(@project)
  end

  private

  def load_project
    @project = Project.find(params[:project_id])
  end
end
