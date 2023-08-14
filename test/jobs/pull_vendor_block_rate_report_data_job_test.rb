# frozen_string_literal: true

require 'test_helper'

class PullVendorBlockRateReportDataJobTest < ActiveJob::TestCase
  describe 'running the job' do
    it 'pulls the data' do
      @vendor = vendors(:batch)
      @current_user = employees(:operations)

      ActionCable.server.expects(:broadcast)
      PullVendorBlockRateReportDataJob.perform_now(@vendor.id, @current_user)
    end
  end
end
