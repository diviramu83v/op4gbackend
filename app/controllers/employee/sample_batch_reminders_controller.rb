# frozen_string_literal: true

# This controller handles sending the reminders for
# sample batch invitations that have already been sent.
class Employee::SampleBatchRemindersController < Employee::OperationsBaseController
  authorize_resource class: 'SampleBatch'

  def create
    @batch = SampleBatch.find(params[:sample_batch_id])

    SampleBatchReminderJob.perform_later(@batch, current_employee)

    flash[:notice] = 'Reminders are being sent.'

    @batch.update!(reminders_started_at: Time.now.utc)

    redirect_to survey_queries_url(@batch.survey)
  end
end
