# frozen_string_literal: true

require 'test_helper'

class Survey::ClientSentUnsubscriptionConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_sent_survey_invitation = client_sent_survey_invitations(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get survey_client_sent_unsubscribe_confirmation_url,
          params: { email: @client_sent_survey_invitation.email, unsubscribe_token: @client_sent_survey_invitation.unsubscribe_token }

      assert_response :ok
    end
  end
end
