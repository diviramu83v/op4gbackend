# frozen_string_literal: true

require 'test_helper'

class ExportPanelistsReportDataJobTest < ActiveJob::TestCase
  describe 'running the job' do
    setup do
      stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/')
        .to_return(status: 200,
                   body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                   headers: { 'Content-Type' => 'application/json' })
    end

    it 'downloads csv' do
      @employee = employees(:operations)

      ActionCable.server.expects(:broadcast)
      ExportPanelistsReportDataJob.perform_now(@employee)
    end
  end
end
