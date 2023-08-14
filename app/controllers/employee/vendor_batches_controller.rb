# frozen_string_literal: true

class Employee::VendorBatchesController < Employee::OperationsBaseController
  authorize_resource
  def index
    @survey = Survey.find(params[:survey_id])
  end

  def new
    @survey = Survey.find(params[:survey_id])
    @batch = @survey.vendor_batches.new
  end

  # rubocop:disable Rails/SkipsModelValidations, Metrics/MethodLength, Metrics/AbcSize
  def create
    @survey = Survey.find(params[:survey_id])
    @batch = @survey.vendor_batches.new(new_vendor_batch_params)

    begin
      if @batch.save
        @survey.project.touch
        redirect_to survey_vendors_url(@survey, anchor: "vendor-#{@batch.vendor.id}")
        if params.dig(:prescreener, :activate) == '1'
          @batch.onramp.update(check_prescreener: true)
        else
          @batch.onramp.update(check_prescreener: false)
        end
      else
        render 'new'
      end
    rescue ActiveRecord::RecordNotUnique
      redirect_to survey_vendors_url(@survey, anchor: "vendor-#{@batch.vendor.id}")
    end
  end
  # rubocop:enable Rails/SkipsModelValidations, Metrics/MethodLength, Metrics/AbcSize

  def edit
    @batch = VendorBatch.find(params[:id])
    @survey = @batch.survey
  end

  def update
    @batch = VendorBatch.find(params[:id])
    @survey = @batch.survey

    if @batch.update(edit_vendor_batch_params)
      flash[:notice] = 'Vendor successfully updated.'
      redirect_to survey_vendors_url(@survey, anchor: "vendor-#{@batch.vendor.id}")
    else
      render 'edit'
    end
  end

  def destroy
    @batch = VendorBatch.find(params[:id])
    @survey = @batch.survey

    if @batch.deletable? && @batch.destroy
      redirect_to survey_vendors_url(@survey), notice: 'Vendor successfully removed.'
    else
      redirect_to survey_vendors_url(@survey), alert: 'Unable to remove vendor.'
    end
  end

  private

  def new_vendor_batch_params
    params.require(:vendor_batch).permit(:vendor_id, :incentive, :complete_url, :terminate_url, :overquota_url, :security_url,
                                         :quoted_completes, :requested_completes)
  end

  def edit_vendor_batch_params
    params.require(:vendor_batch).permit(:incentive, :complete_url, :terminate_url, :overquota_url, :security_url, :quoted_completes, :requested_completes)
  end
end
