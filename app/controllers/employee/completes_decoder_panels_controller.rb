# frozen_string_literal: true

class Employee::CompletesDecoderPanelsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def show
    @decoding = CompletesDecoder.find(params[:completes_decoder_id])
    @panel = Panel.find(params[:id])
    @decodings = @decoding.decoded_uids_for_panel(@panel).includes(:onboarding).order(:entry_number)

    respond_to do |format|
      format.html
      format.csv do
        filename = if @decoding.multiple_projects?
                     "panel-#{@panel.slug}-traffic-decoded-uids.csv"
                   else
                     @decoding.filename(uids: @decodings, source_object: @panel)
                   end

        send_data @decodings.to_source_csv, filename: filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
