# frozen_string_literal: true

class Employee::SampleBatchClonesController < Employee::OperationsBaseController
  authorize_resource class: 'SampleBatch'

  def create
    @batch = SampleBatch.find(params[:sample_batch_id])

    if SampleBatch.create(@batch.clonable_fields)
      flash[:notice] = 'Successfully cloned batch.'
    else
      flash[:alert] = 'Unable to clone batch.'
    end

    redirect_to survey_queries_url(@batch.survey)
  end
end
