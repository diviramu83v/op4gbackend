# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectReportControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    load_and_sign_in_admin

    stub_request(:any, %r{op4g-project-reports.s3.amazonaws.com/project_reports/data})
      .to_return(status: 200, body: '', headers: {})

    stub_request(:get, /s3.amazonaws.com/)
      .to_return(status: 200, body: '', headers: {})

    stub_request(:get, /security-credentials/)
      .to_return(status: 200, body: '', headers: {})

    ProjectReport.create(
      report_file_name: 'data',
      report_content_type: 'text/plain',
      report_file_size: 9000,
      report_updated_at: Time.now.utc
    )
  end

  it 'should create a new ProjectReport job' do
    assert_enqueued_jobs 0

    post project_report_url

    assert_enqueued_jobs 1
    assert_response :no_content
  end

  it 'should create a new ProjectReport if one was not found' do
    ProjectReport.delete_all

    assert_enqueued_jobs 0

    post project_report_url

    assert_enqueued_jobs 1
    assert_response :no_content
  end

  it 'should respond with the last ProjectReport' do
    get project_report_url

    assert_enqueued_jobs 0
    assert_response :ok
    assert_equal 'application/xlsx', response.content_type
  end

  it 'should handle there being no reports yet' do
    ProjectReport.delete_all

    get project_report_url

    assert_enqueued_jobs 0
    assert_redirected_to projects_url
  end
end
