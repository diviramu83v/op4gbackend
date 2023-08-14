# frozen_string_literal: true

require 'test_helper'

class ExportProjectCompletesReportDataJobTest < ActiveSupport::TestCase
  describe 'running the job' do
    setup do
      Sidekiq::Testing.inline!
      @employee = employees(:operations)
      @project = projects(:standard)
    end

    it 'should queue correctly' do
      assert_equal 'ui', CreateSchlesingerQuotaJob.queue
    end

    it 'downloads csv' do
      ActionCable.server.expects(:broadcast)
      ExportProjectCompletesReportDataJob.perform_async(@employee.id, @project.id)
    end
  end
end
