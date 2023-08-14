# frozen_string_literal: true

require 'test_helper'

class DeleteVendorCloseOutDownloadFileJobTest < ActiveJob::TestCase
  test 'is enqueued' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: DeleteVendorCloseOutDownloadFileJob) do
      DeleteVendorCloseOutDownloadFileJob.perform_later('file_name.xls')
    end

    assert_enqueued_jobs 1
  end
end
