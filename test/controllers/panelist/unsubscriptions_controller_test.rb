# frozen_string_literal: true

require 'test_helper'

class Panelist::UnsubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @panelist = panelists(:standard)
    @invitation = project_invitations(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get unsubscribe_url, params: { email: @panelist.email, unsubscribe_token: @invitation.token }

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should create an unsubscription' do
      assert_difference -> { Unsubscription.count } do
        post unsubscribe_url, params: { email: @panelist.email, unsubscribe_token: @invitation.token }
      end
    end

    it 'should not create an unsubscription when no panelist is found' do
      assert_no_difference -> { Unsubscription.count } do
        post unsubscribe_url, params: { email: 'nopanelist@test.com', unsubscribe_token: @invitation.token }
      end
    end

    it 'should render not found when no panelist is found' do
      post unsubscribe_url, params: { email: 'nopanelist@test.com', unsubscribe_token: @invitation.token }

      assert_template 'not_found'
    end
  end
end
