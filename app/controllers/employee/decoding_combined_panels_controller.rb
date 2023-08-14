# frozen_string_literal: true

class Employee::DecodingCombinedPanelsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def show
    @decoding = Decoding.find(params[:decoding_id])
    @decodings = Panel.all.map { |p| @decoding.decoded_uids_for_panel(p).includes(:onboarding).order(:entry_number) }.flatten

    respond_to do |format|
      format.html
      format.csv do
        filename = @decoding.filename(uids: @decodings, source_object: @decoding.first_panel)

        file = CSV.generate do |csv|
          csv << ['UID'] # , 'Payout']

          @decodings.each do |decoding|
            csv << [decoding.onboarding.uid]
          end
        end

        send_data file, filename: filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
