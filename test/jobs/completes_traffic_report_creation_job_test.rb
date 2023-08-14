# frozen_string_literal: true

require 'test_helper'

class CompletesTrafficReportCreationJobTest < ActiveJob::TestCase
  setup do
    @survey = surveys(:standard)

    stub_request(:any, %r{op4g-traffic-reports.s3.amazonaws.com/traffic_reports})
      .to_return(status: 200, body: '', headers: {})
  end

  it 'is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: CompletesTrafficReportCreationJob) do
      CompletesTrafficReportCreationJob.perform_later(@survey)
    end

    assert_enqueued_jobs 1
  end

  it 'creates the traffic report appropriately' do
    TrafficReport.destroy_all
    assert TrafficReport.count.zero?
    CompletesTrafficReportCreationJob.perform_now(@survey)
    assert_equal TrafficReport.count, 1
  end
end
