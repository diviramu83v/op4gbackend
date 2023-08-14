# frozen_string_literal: true

class Employee::DecodingApiVendorsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def show
    @decoding = Decoding.find(params[:decoding_id])
    @vendor = Vendor.find(params[:id])
    @decodings = @decoding.matched_uids_for_api_vendor(@vendor).includes(:onboarding).order(:entry_number)

    respond_to do |format|
      format.html
      format.csv do
        filename = if @decoding.multiple_projects?
                     "#{@vendor.name.parameterize}-decoded-uids.csv"
                   else
                     @decoding.filename(uids: @decodings, source_object: @vendor)
                   end

        send_data @decodings.to_source_csv, filename: filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
