# frozen_string_literal: true

require 'test_helper'

class ExportRecruitmentSourceDataJobTest < ActiveJob::TestCase
  describe 'running the job' do
    it 'downloads csv' do
      @employee = employees(:operations)

      ActionCable.server.expects(:broadcast)
      ExportRecruitmentSourceDataJob.perform_now(@employee, '11/01/2020', '03/09/2021')
    end
  end
end
