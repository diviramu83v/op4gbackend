# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectSalespeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  it 'should add a temporary salesperson to a project' do
    @project = projects(:standard)
    @project.update(salesperson_id: nil)
    @employee = employees(:operations)
    @params = { project: { salesperson_id: @employee.id } }

    assert_nil @project.salesperson

    patch project_salesperson_url(@project), params: @params
    @project.reload

    assert_equal(@employee, @project.salesperson)
  end

  # rubocop:disable Rails::SkipsModelValidations
  it 'failure should not attach a salesperson' do
    # Force failure.
    Project.any_instance.stubs(:update).returns(false)

    @project = projects(:standard)
    @project.update_column(:salesperson_id, nil)
    @employee = employees(:operations)
    @params = { project: { salesperson_id: @employee.id } }

    assert_nil @project.salesperson

    patch project_salesperson_url(@project), params: @params

    assert_nil @project.salesperson
  end

  it 'bad data should not attach a salesperson' do
    @project = projects(:standard)
    @project.update_column(:salesperson_id, nil)

    patch project_salesperson_url(@project),
          params: { project: { salesperson_id: nil } },
          headers: @headers
    @project.reload
    assert_nil @project.salesperson

    patch project_salesperson_url(@project),
          params: { project: { salesperson_id: '' } },
          headers: @headers
    @project.reload
    assert_nil @project.salesperson
  end
  # rubocop:enable Rails::SkipsModelValidations
end
