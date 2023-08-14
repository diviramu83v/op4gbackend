# frozen_string_literal: true

require 'test_helper'

class ExportBlockRateBySourceReportJobTest < ActiveJob::TestCase
  describe 'running the job' do
    it 'downloads csv' do
      @employee = employees(:operations)

      ActionCable.server.expects(:broadcast)
      ExportBlockRateBySourceReportJob.perform_now(@employee, {'start_date' => '2021-07-29', 'end_date' => '2021-08-01', 'source' => ''})
    end
  end
end
