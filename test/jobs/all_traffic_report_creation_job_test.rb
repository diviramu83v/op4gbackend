# frozen_string_literal: true

require 'test_helper'

class AllTrafficReportCreationJobTest < ActiveJob::TestCase
  describe 'traffic report creation' do
    def setup
      project = projects(:standard)
      @survey = surveys(:standard)

      project.surveys << [@survey]

      stub_request(:any, %r{op4g-traffic-reports.s3.amazonaws.com/traffic_reports})
        .to_return(status: 200, body: '', headers: {})
    end

    def teardown
      @survey = nil
    end

    it 'is enqueued properly' do
      AllTrafficReportCreationJob.perform_async(@survey.id)
      assert_equal 'ui', AllTrafficReportCreationJob.queue
    end

    it 'creates the traffic report appropriately' do
      TrafficReport.destroy_all
      assert TrafficReport.count.zero?
      job = AllTrafficReportCreationJob.new
      job.perform(@survey.id)
      assert TrafficReport.count == 1
    end
  end
end
