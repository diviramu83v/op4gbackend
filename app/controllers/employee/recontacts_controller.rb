# frozen_string_literal: true

class Employee::RecontactsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'
  before_action :load_recontact_and_project, only: [:show, :edit, :update]

  def show
    @recontact_invitation_batch = RecontactInvitationBatch.find_by(id: params[:batch_id])

    return unless @recontact_invitation_batch

    flash.now[:alert] = 'No email addresses found.' if @recontact_invitation_batch.no_valid_ids?
  end

  def edit; end

  def create
    @project = Project.find(params[:project_id])
    @project.add_recontact

    redirect_to project_url(@project)
  end

  def update
    if @recontact.update(survey_params)
      redirect_to recontact_url(@recontact)
    else
      render 'edit'
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:name, :base_link, :target, :cpi, :loi, :prevent_overlapping_invitations, :category)
  end

  def load_recontact_and_project
    @recontact = Survey.find(params[:id])
    @project = @recontact.project
  end
end
