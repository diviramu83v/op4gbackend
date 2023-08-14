# frozen_string_literal: true

require 'test_helper'

class ExportBlockReasonsReportJobTest < ActiveJob::TestCase
  describe 'running the job' do
    it 'downloads csv' do
      @employee = employees(:operations)

      ActionCable.server.expects(:broadcast)
      ExportBlockReasonsReportJob.perform_now(@employee, 'August', '2022')
    end
  end
end
