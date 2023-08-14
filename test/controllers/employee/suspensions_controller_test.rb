# frozen_string_literal: true

require 'test_helper'

class Employee::SuspensionsControllerTest < ActionDispatch::IntegrationTest
  it 'suspends a panelist' do
    stub_request(:post, /madmimi.com/).to_return(status: 200, body: '', headers: {})

    load_and_sign_in_panelist_editor_employee

    @panelist = panelists(:standard)

    post panelist_suspension_url(@panelist)

    assert_redirected_to @panelist
  end

  it 'removes the suspension of a panelist' do
    load_and_sign_in_panelist_editor_employee

    @panelist = panelists(:standard)

    delete panelist_suspension_url(@panelist)

    assert_redirected_to @panelist
  end
end
