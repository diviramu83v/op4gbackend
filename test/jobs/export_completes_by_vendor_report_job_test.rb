# frozen_string_literal: true

require 'test_helper'

class ExportCompletesByVendorReportJobTest < ActiveJob::TestCase
  describe 'running the job' do
    it 'downloads csv' do
      employee = employees(:operations)
      vendor = vendors(:batch)

      ActionCable.server.expects(:broadcast)
      ExportCompletesByVendorReportJob.perform_now(employee, '2022-08-01', '2022-09-01', vendor.id)
    end

    it 'downloads csv with vendor nil' do
      employee = employees(:operations)

      ActionCable.server.expects(:broadcast)
      ExportCompletesByVendorReportJob.perform_now(employee, '2022-08-01', '2022-09-01', nil)
    end
  end
end
