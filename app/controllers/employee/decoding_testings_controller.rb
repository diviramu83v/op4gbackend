# frozen_string_literal: true

class Employee::DecodingTestingsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  # rubocop:disable Metrics/MethodLength
  def show
    @decoding = Decoding.find(params[:decoding_id])
    @decodings = @decoding.testing_traffic_uids.includes(:onboarding).order(:entry_number)

    respond_to do |format|
      format.html
      format.csv do
        if @decoding.multiple_projects?
          filename = 'testing-decoded-uids.csv'
        else
          project = @decoding.projects.first
          filename = "#{project.id}-testing-decoded-uids.csv"
        end

        send_data @decodings.to_source_csv, filename: filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
