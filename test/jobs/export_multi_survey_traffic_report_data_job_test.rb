# frozen_string_literal: true

require 'test_helper'

class ExportMultiSurveyTrafficReportDataJobTest < ActiveSupport::TestCase
  describe 'running the job' do
    setup do
      Sidekiq::Testing.inline!
      @employee = employees(:operations)
      @project = projects(:standard)
      @survey_ids = @project.surveys.pluck(:id)
      @report_type = 'all_traffic'
    end
    it 'should queue correctly' do
      ExportMultiSurveyTrafficReportDataJob.perform_async(@employee.id, @survey_ids, @report_type)

      assert_equal 'ui', ExportMultiSurveyTrafficReportDataJob.queue
    end

    it 'downloads csv' do
      ActionCable.server.expects(:broadcast)
      ExportMultiSurveyTrafficReportDataJob.perform_async(@employee.id, @survey_ids, @report_type)
    end
  end
end
