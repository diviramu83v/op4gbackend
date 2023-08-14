# frozen_string_literal: true

require 'test_helper'

class Employee::PanelistNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:operations)
    @employee.roles << Role.find_by(name: 'Panelist editor')
    sign_in(@employee)
    @panelist = panelists(:standard)
    @note = panelist_notes(:standard)
  end

  it 'shows the view to create a new note' do
    get new_panelist_note_url(@panelist), headers: @auth_headers

    assert_ok_with_no_warning
  end

  it 'creates a new note and returns back to panelist page' do
    assert_difference -> { PanelistNote.count }, 1 do
      post panelist_notes_url(@panelist), params: { panelist_note: { body: 'test note' } }, headers: @auth_headers
    end

    assert_redirected_to panelist_url(@panelist)
  end

  it 'redirects back to the new note view if the note param is empty' do
    assert_difference -> { PanelistNote.count }, 0 do
      post panelist_notes_url(@panelist), params: { panelist_note: { body: '' } }, headers: @auth_headers
    end

    assert_response :ok
  end
end
