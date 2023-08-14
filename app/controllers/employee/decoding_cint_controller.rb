# frozen_string_literal: true

class Employee::DecodingCintController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  def show
    @decoding = Decoding.find(params[:decoding_id])
    @decodings = @decoding.matched_uids_for_cint.includes(:onboarding).order(:entry_number)

    respond_to do |format|
      format.html
      format.csv do
        filename = 'cint-decoded-uids.csv'

        send_data @decodings.to_source_csv, filename: filename
      end
    end
  end
end
