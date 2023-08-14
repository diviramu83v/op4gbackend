# frozen_string_literal: true

require 'test_helper'

class Survey::ClientSentUnsubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_sent_survey_invitation = client_sent_survey_invitations(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get survey_client_sent_unsubscribe_url,
          params: { email: @client_sent_survey_invitation.email, unsubscribe_token: @client_sent_survey_invitation.unsubscribe_token }

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should create an unsubscription' do
      assert_difference -> { ClientSentUnsubscription.count } do
        post survey_client_sent_unsubscriptions_url,
             params: { email: @client_sent_survey_invitation.email, unsubscribe_token: @client_sent_survey_invitation.unsubscribe_token }
      end
    end
  end
end
