# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectWorkOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  it 'updates the project work order' do
    @project = projects(:standard)

    put project_work_order_url(@project), params: { project: @project.attributes }

    assert_redirected_to projects_url
  end
end
