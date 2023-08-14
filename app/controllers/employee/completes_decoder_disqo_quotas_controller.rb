# frozen_string_literal: true

class Employee::CompletesDecoderDisqoQuotasController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  # rubocop:disable Metrics/MethodLength
  def show
    @decoding = CompletesDecoder.find(params[:completes_decoder_id])
    @disqo_quota = DisqoQuota.find(params[:id])
    @decodings = @decoding.matched_uids_for_disqo(@disqo_quota)

    respond_to do |format|
      format.html
      format.csv do
        filename = if @decoding.multiple_projects?
                     "disqo-#{@disqo_quota.quota_id}-decoded-uids.csv"
                   else
                     @decoding.filename(uids: @decodings, source_object: @disqo_quota)
                   end

        send_data @decodings.to_source_csv, filename: filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
