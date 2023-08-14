# frozen_string_literal: true

require 'test_helper'

class Employee::QueryProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'should retrieve new project page with a query' do
    query = demo_queries(:standard)

    get new_query_project_url(query)

    assert_response :ok
  end

  it 'should create a new project with a query' do
    query = demo_queries(:standard)
    project_params = { project: { name: 'Project with a query' } }

    assert_difference -> { Project.count }, 1 do
      post query_projects_url(query), params: project_params
    end
    new_project = Project.last

    assert_includes new_project.queries, query
  end

  it 'should notify when unable to save project' do
    # Force failure.
    Project.any_instance.stubs(:save).returns(false)

    query = demo_queries(:standard)
    project_params = { project: { name: 'Project with a query' } }

    assert_no_difference -> { Project.count } do
      post query_projects_url(query), params: project_params
    end

    assert_not_nil flash[:alert]
  end
end
