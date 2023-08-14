# frozen_string_literal: true

require 'test_helper'

class VendorPerformanceReportJobTest < ActiveJob::TestCase
  setup do
    @employee = employees(:operations)
    @client = clients(:standard)
    @country = countries(:standard)
    @month = Time.zone.today.strftime('%B')
    @year = Time.zone.today.strftime('%Y')
  end

  describe 'running the job' do
    it 'downloads csv' do
      ActionCable.server.expects(:broadcast)
      VendorPerformanceReportJob.perform_now(user: @employee, client_id: @client.id, month: @month, year: @year,
                                             audience: 'Test Audience', country_id: @country.id)
    end
  end
end
