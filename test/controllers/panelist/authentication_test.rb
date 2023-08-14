# frozen_string_literal: true

require 'test_helper'

# Testing one route per controller. Testing every route is probably overkill
# for most controllers, because permissions will likely be handled at the
# controller level.
class Panelist::AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    # TODO: some/most of these redirects to sign might end up being 401s instead
    load_and_sign_in_confirmed_panelist_with_base_info
  end

  ###
  # / (root domain)
  ###

  it 'root dashboard' do
    get dashboard_url

    assert_redirected_with_warning
  end

  ###
  # /employee
  ###

  it 'employee session' do
    get new_employee_session_url

    assert_ok_with_no_warning
  end

  it 'employee dashboard' do
    get employee_dashboard_url

    assert_redirected_with_warning
  end

  it 'operations dashboard' do
    get operations_dashboard_url

    assert_redirected_with_warning
  end

  it 'demo queries' do
    get new_query_url

    assert_redirected_with_warning
  end

  it 'demo query options' do
    load_no_option_query

    post query_options_url(@query)

    assert_redirected_with_warning
  end

  it 'demo query project' do
    load_query

    get new_query_project_url(@query)

    assert_redirected_with_warning
  end

  it 'projects' do
    get projects_url

    assert_redirected_with_warning
  end

  it 'survey vendor batch' do
    @survey = surveys(:standard)

    get new_survey_vendor_url(@survey)

    assert_redirected_with_warning
  end

  it 'project salesperson' do
    @project = projects(:standard)
    @employee = employees(:sales)
    params = { project: { salesperson_id: @employee.id } }

    put project_salesperson_url(@project, params: params)

    assert_redirected_with_warning
  end

  it 'project status' do
    @project = projects(:standard)

    get project_statuses_url(@project, id: 'live')

    assert_redirected_with_warning
  end

  it 'sample batch' do
    load_query

    get new_query_sample_url(@query)

    assert_redirected_with_warning
  end

  it 'sample batch launch' do
    @sample_batch = sample_batches(:standard)

    post sample_batch_launch_url(@sample_batch)

    assert_redirected_with_warning
  end

  it 'vendors' do
    get vendors_url

    assert_redirected_with_warning
  end

  it 'clients' do
    get clients_url

    assert_redirected_with_warning
  end

  it 'client projects' do
    @client = clients(:standard)

    get new_client_project_url(@client)

    assert_redirected_with_warning
  end

  ###
  # /panelist
  ###

  it 'panelist session' do
    get new_panelist_session_url

    assert_redirected_with_warning
  end

  # TODO: Shouldn't be able to reach all of these pages if already signed up.
  # it 'base demographics' do
  #   get base_demographics_url
  #
  #   assert_ok_with_no_warning
  # end

  # it 'panel demographics' do
  #   get demographics_url
  #
  #   assert_ok_with_no_warning
  # end

  it 'dashboard' do
    get panelist_dashboard_url

    assert_ok_with_no_warning
  end

  it 'survey start' do
    @invitation = project_invitations(:standard)
    @invitation.sent!

    get invitation_url(@invitation.token)

    assert_redirected_with_no_warning
  end

  ###
  # /admin
  ###

  it 'admin dashboard' do
    get admin_dashboard_url

    assert_employee_signin_required
  end

  it 'events list' do
    get events_url

    assert_employee_signin_required
  end

  it 'jobs dashboard' do
    get jobs_url

    assert_employee_signin_required
  end

  ###
  # /survey
  ###

  # Survey responses are intentionally not secured.

  it 'survey response' do
    @survey_response = survey_response_urls(:complete)

    get survey_response_url(@survey_response)

    assert_redirected_to survey_error_url
  end

  ###
  # /testing
  ###

  it 'test survey' do
    @survey = surveys(:standard)

    get test_survey_url(@survey.token)

    assert_employee_signin_required
  end
end
