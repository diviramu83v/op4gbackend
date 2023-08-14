# frozen_string_literal: true

class Employee::SampleBatchLaunchesController < Employee::OperationsBaseController
  authorize_resource class: 'SampleBatch'

  def create
    @batch = SampleBatch.find(params[:sample_batch_id])

    if @batch.send_invitations(current_employee)
      flash[:notice] = invitation_success_notice
    else
      flash[:alert] = 'Unable to send invitations.'
    end

    redirect_to survey_queries_url(@batch.survey)
  end

  private

  def invitation_success_notice
    job_count = JobQueueViewer.new('invitations').size

    "Successfully enqueued #{@batch.invitation_count} #{'invitation'.pluralize(@batch.invitation_count)}. " \
      "#{job_count} #{'invitation'.pluralize(job_count)} already in the queue."
  end
end
