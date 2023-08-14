# frozen_string_literal: true

class Admin::PaymentsController < Admin::BaseController
  def index
    @payment_upload_batches = PaymentUploadBatch.most_recent_first.includes(:payments, :employee)
  end

  def new
    @payment_upload_batch = PaymentUploadBatch.new
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @payment_upload_batch = PaymentUploadBatch.new(batch_params.merge(employee: current_employee))

    if @payment_upload_batch.save
      if @payment_upload_batch.error_data.nil?
        flash[:notice] = 'Payment batch saved successfully.'
      else
        flash[:alert] = "Errors while processing batch. Some rows not processed:\r\n\r\n#{@payment_upload_batch.error_data}".gsub("\r\n", '<br>')
      end

      redirect_to payments_url
    else
      flash.now[:alert] = 'Unable to save payment batch.'
      render 'new'
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def batch_params
    params.require(:payment_upload_batch).permit(:paid_at, :period, :payment_data)
  end
end
