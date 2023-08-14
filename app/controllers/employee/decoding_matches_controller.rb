# frozen_string_literal: true

class Employee::DecodingMatchesController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  # rubocop:disable Metrics/MethodLength
  def show
    @decoding = Decoding.find(params[:decoding_id])
    @decodings = @decoding.decoded_uids.order(:entry_number)

    respond_to do |format|
      format.html
      format.csv do
        if @decoding.multiple_projects?
          filename = 'all-decoded-uids.csv'
        else
          project = @decoding.projects.first
          filename = "#{project.id}-all-decoded-uids.csv"
        end

        send_data @decodings.to_combined_panel_csv, filename: filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
