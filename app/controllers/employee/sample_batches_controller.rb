# frozen_string_literal: true

class Employee::SampleBatchesController < Employee::OperationsBaseController
  authorize_resource

  def new
    @query = DemoQuery.find(params[:query_id])
    @survey = @query.survey

    batch_data = @query.next_sample_batch_fields
    @batch = @query.sample_batches.new(batch_data)
  end

  def create
    @query = DemoQuery.find(params[:query_id])
    @batch = @query.sample_batches.new(sample_batch_params)
    @survey = @query.survey

    if @batch.save
      flash[:notice] = 'Invitations are being created in the background; refresh the page before sending invitations.'
      redirect_to survey_queries_url(@survey)
    else
      render 'new'
    end
  end

  def edit
    @batch = SampleBatch.find(params[:id])
    @survey = @batch.survey
  end

  def update
    @batch = SampleBatch.find(params[:id])
    @survey = @batch.survey

    if @batch.update(sample_batch_params)
      redirect_to survey_queries_url(@survey)
    else
      render 'edit'
    end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def destroy
    @batch = SampleBatch.find(params[:id])

    if @batch.creating_invitations?
      flash[:alert] = 'Invitations are generating for the batch you tried to delete. Please wait a little while and then try again.'
      return redirect_to survey_queries_url(@batch.survey)
    end
    unless @batch.removable?
      flash[:alert] = 'This batch cannot be deleted'
      return redirect_to survey_queries_url(@batch.survey)
    end

    @batch.destroy!

    redirect_to survey_queries_url(@batch.survey)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def sample_batch_params
    params.require(:sample_batch).permit(:label, :incentive, :count, :email_subject, :description, :soft_launch_batch)
  end
end
