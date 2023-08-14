# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectProductControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_operations_employee

    @project = projects(:standard)
  end

  it 'updates the project product' do
    put project_product_url(@project), params: { project: @project.attributes }

    assert_redirected_to projects_url
  end
end
