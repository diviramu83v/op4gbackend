# frozen_string_literal: true

require 'test_helper'

class TrafficReportTest < ActiveSupport::TestCase
  setup do
    stub_request(:any, %r{op4g-traffic-reports.s3.amazonaws.com/traffic_reports})
      .to_return(status: 200, body: '', headers: {})
  end

  it 'sends a message to the TrafficReportsChannel when the report is built' do
    message = 'completes'

    TrafficReportsChannel.expects(:broadcast_to).with('all', message)

    @survey = surveys(:standard)
    @traffic_report = @survey.traffic_reports.create!(report_type: 'completes')
  end
end
