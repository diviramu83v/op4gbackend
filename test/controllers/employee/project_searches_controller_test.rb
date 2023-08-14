# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectSearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
    @project = projects(:standard)
    @survey = surveys(:second)
  end

  it 'should find a project from the nav search' do
    post project_search_url, params: { project_search: { project_work_order_or_survey_number: 1 } }

    assert_generates '/projects/1', controller: 'employee/projects', action: 'show', id: '1'
  end

  it 'should find the project by project id' do
    post project_search_url, params: { project_search: { project_work_order_or_survey_number: @project.id } }

    assert_redirected_to project_url(@project)
    assert_nil flash[:alert]
  end

  it 'should find the project by work order' do
    post project_search_url, params: { project_search: { project_work_order_or_survey_number: @project.work_order } }

    assert_redirected_to project_url(@project)
    assert_nil flash[:alert]
  end

  it 'should find the project by name' do
    post project_search_url, params: { project_search: { project_work_order_or_survey_number: @project.name } }

    assert_redirected_to project_url(@project)
    assert_nil flash[:alert]
  end

  it 'should find the survey by survey id' do
    post project_search_url, params: { project_search: { project_work_order_or_survey_number: @survey.id } }

    assert_redirected_to survey_url(@survey)
    assert_nil flash[:alert]
  end

  it 'should flash an alert and redirect to the employee dashboard if project or survey not found' do
    post project_search_url, params: { project_search: { project_work_order_or_survey_number: 4567 } }

    assert_redirected_to employee_dashboard_url
    assert_equal 'Project or survey not found', flash[:alert]
  end
end
