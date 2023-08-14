# frozen_string_literal: true

require 'test_helper'

class Employee::VendorCloseOutReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @project = projects(:standard)
    stub_disqo_project_and_quota_status_change
    SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
    @project.surveys.each do |survey|
      survey.assign_status('finished')
      survey.save!
    end
  end

  describe '#index' do
    it 'should load the page' do
      get project_vendor_close_out_reports_url(@project)

      assert_response :ok
    end
  end
end
