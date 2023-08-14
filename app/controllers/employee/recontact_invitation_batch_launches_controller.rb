# frozen_string_literal: true

class Employee::RecontactInvitationBatchLaunchesController < Employee::OperationsBaseController
  authorize_resource class: 'RecontactInvitationBatch'

  def create
    @batch = RecontactInvitationBatch.find(params[:recontact_invitation_batch_id])

    if @batch.send_invitations(current_employee)
      flash[:notice] = invitation_success_notice
    else
      flash[:alert] = 'Unable to send invitations.'
    end

    redirect_to recontact_url(@batch.survey)
  end

  private

  def invitation_success_notice
    job_count = JobQueueViewer.new('invitations').size

    "Successfully enqueued #{@batch.invitation_count} #{'invitation'.pluralize(@batch.invitation_count)}. " \
      "#{job_count} #{'invitation'.pluralize(job_count)} already in the queue."
  end
end
