# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    stub_disqo_project_and_quota_status_change
  end

  it 'should change the surveys statuses from draft to live' do
    @project = projects(:standard)
    @project.surveys.each { |survey| survey.vendor_batches << vendor_batches(:standard) }

    post project_statuses_url(@project, id: 'live')
    @project.reload

    assert @project.surveys.all?(&:live?)
  end

  it 'going live sets the surveys started_at column' do
    @project = projects(:standard)
    @project.surveys.each do |survey|
      survey.update!(status: 'draft')
    end

    post project_statuses_url(@project, id: 'live')
    @project.reload

    assert(@project.surveys.all? { |survey| survey.started_at.present? })
  end

  it 'closing out saves the project finish date' do
    SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
    @project = projects(:standard)

    assert_nil @project.finished_at

    post project_statuses_url(@project, id: 'live')
    post project_statuses_url(@project, id: 'finished')
    @project.reload

    assert @project.surveys.all?(&:finished?)
  end

  it 'no status change for invalid project' do
    @project = Project.create(manager: employees(:operations), name: Faker::Name.name, product_name: 'sample_only')

    post project_statuses_url(@project, id: 'live')
    @project.reload

    assert @project.surveys.all?(&:draft?)
  end

  it 'no status change for invalid survey' do
    @project = projects(:standard)
    @survey = @project.surveys.first
    assert_not_nil @survey

    @survey.update(base_link: nil, status: 'draft')

    post project_statuses_url(@project, id: 'live')
    @project.reload
    assert @survey.draft?
  end

  it 'no status change if invalid status given' do
    @project = projects(:standard)
    @project.surveys << Survey.create(target: 450, loi: 15, cpi_cents: 1700, base_link: 'https://test.com?pid={{uid}}', name: 'test survey',
                                      category: 'standard', status: 'draft')

    assert @project.surveys.last(&:draft?)

    post project_statuses_url(@project, id: 'crazy')
    @project.reload

    assert @project.surveys.last(&:draft?)
  end

  it 'renders the survey edit page if any of the surveys don\'t save' do
    @project = projects(:standard)
    @project.surveys.each do |survey|
      survey.update(status: 'draft')
      survey.vendor_batches << vendor_batches(:standard)
    end

    Survey.any_instance.expects(:save).returns(false)

    assert @project.surveys.all?(&:draft?)

    post project_statuses_url(@project, id: 'live')

    assert @project.surveys.all?(&:draft?)
  end

  it 'renders the surveys#edit page with an alert about being unable to update the project status if the survey is not valid' do
    @project = projects(:standard)
    @project.surveys.each { |survey| survey.vendor_batches << vendor_batches(:standard) }
    @survey = @project.surveys.first
    assert_not_nil @survey

    @survey.update(base_link: nil)
    @project.surveys.each do |survey|
      survey.update(status: 'draft')
    end

    Survey.any_instance.stubs(:valid?).returns(false)

    post project_statuses_url(@project, id: 'live')
    @project.reload

    assert @project.surveys.all?(&:draft?)
  end

  it 'renders the vendor_batches#edit page with an alert about being unable to update the batch if the batch is not valid' do
    @project = Project.create(manager: employees(:operations), name: Faker::Name.name, product_name: 'sample_only')
    @project.surveys << surveys(:standard)
    @project.surveys.each { |survey| survey.vendor_batches << vendor_batches(:standard) }

    post project_statuses_url(@project, id: 'live')
    @project.reload

    assert @project.surveys.all?(&:live?)
  end
end
