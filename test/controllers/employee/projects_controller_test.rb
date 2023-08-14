# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  it 'should retrieve project list' do
    get projects_url

    assert_response :ok
    assert_template :index
  end

  it 'should display surveys links' do
    project = projects(:standard)
    survey = project.surveys.last

    get survey_url(survey)

    assert_response :ok
    assert_equal "/surveys/#{survey.id}", survey_path(survey)
  end

  it 'should retrieve project page' do
    project = projects(:standard)

    get project_url(project)

    # Project page redirects to default campaign.
    assert_ok_with_no_warning
  end

  it 'should retrieve new project page' do
    get new_project_url

    assert_response :ok
  end

  describe '#edit' do
    setup do
      @project = projects(:standard)
    end

    it 'should load the edit page' do
      get edit_project_url(@project)

      assert_response :ok
    end
  end

  it 'should not create a new project' do
    assert_no_difference -> { Project.count } do
      post projects_url, params: { project: { name: nil } }
    end
  end

  it 'should create a new project' do
    assert_difference -> { Project.count } do
      post projects_url, params: { project: { name: 'test project' } }
    end

    assert_redirected_to edit_project_url(Project.last)
  end

  it 'new project has a campaign that has an onramp with relevantID and recaptcha turned on by default' do
    post projects_url, params: { project: { name: 'test_name' } }

    @project = Project.where(name: 'test_name').first

    assert_equal @project.surveys.first.onramps.first.check_recaptcha, true
  end

  it 'should create a survey' do
    project_params = { project: { name: 'A new project' } }

    assert_difference -> { Survey.count }, 1 do
      post projects_url, params: project_params
    end
    new_project = Project.last

    assert_equal 1, new_project.surveys.count
  end

  describe '#update' do
    setup do
      @project = projects(:standard)
    end

    it 'should update a project' do
      assert_no_difference -> { Project.count } do
        patch project_url(@project), params: { project: { name: 'new name' } }
      end

      assert_redirected_to project_url(@project)
    end

    it 'should fail to update a project' do
      assert_no_difference -> { Project.count } do
        patch project_url(@project), params: { project: { name: '' } }
      end

      assert_template :edit
    end
  end
end
