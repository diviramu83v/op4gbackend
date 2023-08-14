# frozen_string_literal: true

class Employee::DecodingErrorsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  def show
    @decoding = Decoding.find(params[:decoding_id])
    @failed_decodings = @decoding.unmatched_uids

    respond_to do |format|
      format.html
      format.csv do
        send_data @failed_decodings.to_errors_csv, filename: 'decoder-errors.csv'
      end
    end
  end
end
