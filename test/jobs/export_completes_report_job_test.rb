# frozen_string_literal: true

require 'test_helper'

class ExportCompletesReportJobTest < ActiveJob::TestCase
  describe 'running the job' do
    it 'downloads csv' do
      @employee = employees(:operations)

      ActionCable.server.expects(:broadcast)
      ExportCompletesReportJob.perform_now(@employee, 'Accepted', 'August', '2022')
    end
  end
end
