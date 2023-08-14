# frozen_string_literal: true

class Employee::CompletesDecoderCintSurveysController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  # rubocop:disable Metrics/MethodLength
  def show
    @decoding = CompletesDecoder.find(params[:completes_decoder_id])
    @cint_survey = CintSurvey.find(params[:id])
    @decodings = @decoding.matched_uids_for_cint(@cint_survey)

    respond_to do |format|
      format.html
      format.csv do
        filename = if @decoding.multiple_projects?
                     "cint-#{@cint_survey.name}-decoded-uids.csv"
                   else
                     @decoding.filename(uids: @decodings, source_object: @cint_survey)
                   end

        send_data @decodings.to_source_csv, filename: filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
