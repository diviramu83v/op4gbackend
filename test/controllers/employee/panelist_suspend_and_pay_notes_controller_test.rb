# frozen_string_literal: true

require 'test_helper'

class Employee::PanelistSuspendAndPayNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:panelist_editor)
    sign_in(@employee)
    @panelist = panelists(:standard)
  end

  it 'shows the view to create a new note' do
    get new_panelist_suspend_and_pay_note_url(@panelist), headers: @auth_headers

    assert_ok_with_no_warning
  end

  it 'creates a new note and returns back to panelist page' do
    assert_difference -> { PanelistNote.count }, 1 do
      post panelist_suspend_and_pay_notes_url(@panelist), params: { panelist_note: { body: 'test note' } }, headers: @auth_headers
    end

    assert_redirected_to panelist_url(@panelist)
  end

  it 'updates suspend_and_pay_status to true' do
    post panelist_suspend_and_pay_notes_url(@panelist), params: { panelist_note: { body: 'test note' } }, headers: @auth_headers
    @panelist.reload
    assert_equal @panelist.suspend_and_pay_status, true
  end

  it 'does not create a new note and redirects back to the new note view if the note param is empty' do
    assert_no_difference -> { PanelistNote.count } do
      post panelist_suspend_and_pay_notes_url(@panelist), params: { panelist_note: { body: '' } }, headers: @auth_headers
    end

    assert_response :ok
  end
end
