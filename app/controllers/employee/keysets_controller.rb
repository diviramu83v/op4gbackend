# frozen_string_literal: true

class Employee::KeysetsController < Employee::OperationsBaseController
  authorize_resource class: 'Key'

  def destroy
    @survey = Survey.find(params[:survey_id])
    DestroyKeysJob.perform_later(@survey)

    redirect_to survey_keys_url(@survey), notice: 'Unused keys are being removed.'
  end
end
