# frozen_string_literal: true

require 'test_helper'

class Employee::ClientProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'new project page' do
    @client = clients(:standard)

    get new_client_project_url(@client)

    assert_response :ok
  end

  describe '#create' do
    test 'success' do
      @client = clients(:standard)

      project_params = { project: { name: 'Created from client' } }

      assert_difference ['Project.count', 'Survey.count'] do
        post client_projects_url(@client), params: project_params
      end
      project = Project.last

      assert_equal @client, project.client
    end

    test 'failure' do
      # Force failure.
      Project.any_instance.stubs(:save).returns(false)

      @client = clients(:standard)

      project_params = { project: { name: 'Attempted from client' } }

      assert_no_difference -> { Project.count } do
        post client_projects_url(@client), params: project_params
      end
    end
  end
end
