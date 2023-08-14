# frozen_string_literal: true

require 'test_helper'

class ExportPanelCompletesBySourceReportJobTest < ActiveJob::TestCase
  describe 'running the job' do
    it 'downloads csv' do
      @employee = employees(:operations)

      ActionCable.server.expects(:broadcast)
      ExportPanelCompletesBySourceReportJob.perform_now(@employee, 'January', '2020')
    end
  end
end
