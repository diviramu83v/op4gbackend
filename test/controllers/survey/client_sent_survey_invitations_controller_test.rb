# frozen_string_literal: true

require 'test_helper'

class Survey::ClientSentSurveyInvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @onramp = onramps(:client_sent)
    @params = {
      survey_client_sent_survey_invitation: {
        email: 'test@testing.com',
        onramp_id: @onramp.id
      }
    }
    @bad_params = {
      survey_client_sent_survey_invitation: {
        onramp_id: @onramp.id
      }
    }
  end
  describe '#create' do
    it 'should create a client sent survey invitation' do
      assert_difference -> { ClientSentSurveyInvitation.count } do
        post survey_client_sent_survey_invitations_url, params: @params
      end
    end

    it 'should not create a client sent survey invitation' do
      assert_no_difference -> { ClientSentSurveyInvitation.count } do
        post survey_client_sent_survey_invitations_url, params: @bad_params
      end
    end
  end
end
