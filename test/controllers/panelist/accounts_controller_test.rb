# frozen_string_literal: true

require 'test_helper'

class Panelist::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
    assert_not @panelist.inactive?

    stub_request(:post, /madmimi.com/).to_return(status: 200, body: '', headers: {})
    delete account_url
  end

  describe 'DELETE /account' do
    it 'it redirects to panelist sign in page' do
      assert_redirected_to new_panelist_session_url
    end

    it 'displays flash message' do
      assert_equal 'Account successfully deleted.', flash[:notice]
    end

    it 'soft deletes the panelist' do
      assert @panelist.inactive?
    end
  end
end
