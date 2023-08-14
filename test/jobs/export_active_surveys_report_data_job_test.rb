# frozen_string_literal: true

require 'test_helper'

class ExportActiveSurveysReportDataJobTest < ActiveJob::TestCase
  describe 'running the job' do
    setup do
      @employee = employees(:operations)
    end

    it 'downloads csv' do
      ActionCable.server.expects(:broadcast)
      ExportActiveSurveysReportDataJob.perform_now(@employee)
    end
  end
end
