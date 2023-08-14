# frozen_string_literal: true

require 'test_helper'

class Employee::PanelistInvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:panelist_editor)
    sign_in(@employee)
    @panelist = panelists(:standard)
  end

  it 'viewing member invitations is blocked with no credentials' do
    get panelist_invitations_url(@panelist)

    assert_response :unauthorized
  end

  it 'viewing member invitations is blocked with no password' do
    credentials = "#{@employee.email}:"
    auth_headers = { 'Authorization' => "Basic #{Base64.encode64(credentials)}" }

    get panelist_invitations_url(@panelist), headers: auth_headers

    assert_response :unauthorized
  end

  it 'viewing member invitations is blocked with bad password' do
    credentials = "#{@employee.email}:badpassword"
    auth_headers = { 'Authorization' => "Basic #{Base64.encode64(credentials)}" }

    get panelist_invitations_url(@panelist), headers: auth_headers

    assert_response :unauthorized
  end

  it 'viewing member invitations is blocked with mismatched email' do
    credentials = "random@email.com:#{ENV.fetch('MEMBER_DATA_PASSWORD')}"
    auth_headers = { 'Authorization' => "Basic #{Base64.encode64(credentials)}" }

    get panelist_invitations_url(@panelist), headers: auth_headers

    assert_response :unauthorized
  end

  it 'viewing member invitations is allowed with password' do
    credentials = "#{@employee.email}:#{ENV.fetch('MEMBER_DATA_PASSWORD')}"
    auth_headers = { 'Authorization' => "Basic #{Base64.encode64(credentials)}" }

    get panelist_invitations_url(@panelist), headers: auth_headers

    assert_ok_with_no_warning
  end

  it 'should display the invitations show page with rejected completes' do
    credentials = "#{@employee.email}:#{ENV.fetch('MEMBER_DATA_PASSWORD')}"
    auth_headers = { 'Authorization' => "Basic #{Base64.encode64(credentials)}" }
    ProjectInvitation.create(panelist: @panelist, status: 'rejected')
    ProjectInvitation.stubs(:complete).returns(ProjectInvitation.where(panelist: @panelist))

    get panelist_invitations_url(@panelist), headers: auth_headers

    assert_response :success
  end
end
