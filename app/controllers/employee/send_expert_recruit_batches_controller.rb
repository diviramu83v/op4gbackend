# frozen_string_literal: true

class Employee::SendExpertRecruitBatchesController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def create
    expert_recruit_batch = ExpertRecruitBatch.find(params[:expert_recruit_batch_id])
    @survey = expert_recruit_batch.survey
    expert_recruit_batch.start_create_expert_recruits_job
    expert_recruit_batch.sent!
    expert_recruit_batch.update!(sent_at: Time.now.utc)
    flash[:notice] = 'Recruit invites are being sent'

    redirect_to survey_expert_recruit_batches_url(@survey)
  end
end
