# frozen_string_literal: true

class Employee::CompletesDecoderSurveysController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  def show # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @decoding = CompletesDecoder.find(params[:completes_decoder_id])
    @decodings = @decoding.matched_uids.includes(:onboarding).order(:entry_number)
    @project = @decoding.projects.first
    @completes_type = @decoding.onboardings.first.client_status

    respond_to do |format|
      format.html
      format.csv do
        filename = "#{@project.id}_#{@completes_type}_uploads_all_surveys_#{@project.name.parameterize}_N=#{@decodings.count}.csv"

        if @completes_type == 'rejected'
          send_data @decodings.to_source_rejected_csv, filename: filename
        else
          send_data @decodings.to_source_csv, filename: filename
        end
      end
    end
  end
end
