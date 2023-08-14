# frozen_string_literal: true

class Employee::VendorBatchInvitationsController < Employee::OperationsBaseController
  authorize_resource class: 'VendorBatch'

  # AJAX
  def update
    @vendor_batch = VendorBatch.find(params[:vendor_batch_id])

    flash[:alert] = 'Unable to update invitation count.' unless @vendor_batch.update(vendor_batch_params)

    redirect_back fallback_location: survey_url(@vendor_batch.survey)
  end

  private

  def vendor_batch_params
    params.require(:vendor_batch).permit(:invitation_count)
  end
end
