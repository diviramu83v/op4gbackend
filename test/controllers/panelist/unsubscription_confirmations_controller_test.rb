# frozen_string_literal: true

require 'test_helper'

class Panelist::UnsubscriptionConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @panelist = panelists(:standard)
    @invitation = project_invitations(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get unsubscribe_confirmation_url, params: { email: @panelist.email, unsubscribe_token: @invitation.token }

      assert_response :ok
    end
  end
end
