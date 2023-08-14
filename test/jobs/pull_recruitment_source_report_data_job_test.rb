# frozen_string_literal: true

require 'test_helper'

class PullRecruitmentSourceReportDataJobTest < ActiveJob::TestCase
  it 'produces the recruitment source report' do
    start_date = '2020-01-01'
    end_date = '2020-10-01'
    panelist = panelists(:standard)

    RecruitmentSourceReportChannel.expects(:broadcast_to).once
    PullRecruitmentSourceReportDataJob.perform_now(start_date, end_date, panelist)
  end
end
