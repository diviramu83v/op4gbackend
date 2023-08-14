# frozen_string_literal: true

require 'test_helper'

class Employee::VendorCloseOutReportDownloadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @project = projects(:standard)
    @vendor = @project.vendor_batches.first.vendor.name
  end

  describe '#show' do
    it 'should enqueue job - vendor' do
      assert_no_enqueued_jobs

      assert_enqueued_with(job: DeleteVendorCloseOutDownloadFileJob) do
        @file_name = file_name(@project, @vendor)
        get project_vendor_close_out_report_downloads_url(@project, vendor_name: @vendor)
      end

      File.delete(@file_name)
    end

    it 'should enqueue job - quota' do
      assert_no_enqueued_jobs

      assert_enqueued_with(job: DeleteVendorCloseOutDownloadFileJob) do
        @file_name = file_name(@project, 'Disqo')
        get project_vendor_close_out_report_downloads_url(@project, vendor_name: 'Disqo')
      end

      File.delete(@file_name)

      assert_enqueued_with(job: DeleteVendorCloseOutDownloadFileJob) do
        @file_name = file_name(@project, 'Cint')
        get project_vendor_close_out_report_downloads_url(@project, vendor_name: 'Cint')
      end

      File.delete(@file_name)

      assert_enqueued_with(job: DeleteVendorCloseOutDownloadFileJob) do
        @file_name = file_name(@project, 'Schlesinger')
        get project_vendor_close_out_report_downloads_url(@project, vendor_name: 'Schlesinger')
      end

      File.delete(@file_name)
    end
  end

  private

  def file_name(project, vendor_name)
    "#{project.id}_#{vendor_name}_#{Time.zone.now.strftime('%m_%d_%Y')}.xls"
  end
end
