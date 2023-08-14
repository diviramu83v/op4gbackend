# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectClientControllerTest < ActionDispatch::IntegrationTest
  it 'updated the project client\'s id' do
    load_and_sign_in_operations_employee
    @project = projects(:standard)

    put project_client_url(@project), params: { project: @project.attributes }

    assert_redirected_to projects_url
  end
end
