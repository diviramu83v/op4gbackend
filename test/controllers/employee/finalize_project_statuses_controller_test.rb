# frozen_string_literal: true

require 'test_helper'

class Employee::FinalizeProjectStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @project = projects(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get project_finalize_project_statuses_url(@project)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      stub_request(:post, 'https://fuse.cint.com/fulfillment/respondents/Reconciliations')
        .to_return(status: 200, body: '', headers: {})
    end

    it 'should set close out status to finalize' do
      post project_finalize_project_statuses_url(@project)
      @project.reload
      assert_equal 'finalized', @project.close_out_status
    end

    it 'should set project status to finished' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      post project_finalize_project_statuses_url(@project, finished: true)

      assert @project.surveys.all?(&:finished?)
    end

    it 'should not set project status to finished' do
      post project_finalize_project_statuses_url(@project)
      project = Project.find_by(id: @project)
      assert_not project.surveys.any?(&:finished?)
    end
  end
end
