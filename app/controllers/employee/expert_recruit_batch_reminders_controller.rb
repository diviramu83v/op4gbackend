# frozen_string_literal: true

# This controller handles sending the reminders for
# expert recruit batch emails that have already been sent.
class Employee::ExpertRecruitBatchRemindersController < ApplicationController
  authorize_resource class: 'Survey'

  def create
    @expert_recruit_batch = ExpertRecruitBatch.find(params[:expert_recruit_batch_id])

    ExpertRecruitBatchReminderJob.perform_later(@expert_recruit_batch)

    flash[:notice] = 'Reminders are being sent.'

    @expert_recruit_batch.update!(reminders_started_at: Time.now.utc)

    redirect_to survey_expert_recruit_batches_url(@expert_recruit_batch.survey)
  end
end
