# frozen_string_literal: true

class Employee::SampleBatchClosingsController < Employee::OperationsBaseController
  authorize_resource class: 'SampleBatch'
  before_action :find_batch

  def create
    @survey = @batch.survey

    if @batch.close
      flash[:notice] = 'Successfully closed batch.'
    else
      flash[:alert] = 'Unable to close batch.'
    end

    redirect_to survey_queries_url(@survey)
  end

  def destroy
    @survey = @batch.survey

    if @batch.open
      flash[:notice] = 'Successfully re-opened batch.'
    else
      flash[:alert] = 'Unable to re-open batch.'
    end

    redirect_to survey_queries_url(@survey)
  end

  private

  def find_batch
    @batch = SampleBatch.find(params[:sample_batch_id])
  end
end
