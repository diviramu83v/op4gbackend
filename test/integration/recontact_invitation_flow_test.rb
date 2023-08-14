# frozen_string_literal: true

require 'test_helper'

class RecontactInvitationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @recontact_invitation_batch = recontact_invitation_batches(:standard)
    @survey = @recontact_invitation_batch.survey
    @survey.update!(category: :recontact)
    @onboarding = onboardings(:standard)
    @onboarding.onramp.update!(category: :recontact)
    @recontact_invitation = @recontact_invitation_batch.create_invitation(@onboarding.token, 'http://www.test.com/{{uid}}/{{old_uid}}')
    @onramp = @survey.onramp_for_recontact(@survey)
  end

  describe 'happy path' do
    it 'correctly follows flow' do
      get survey_recontact_invitation_url(@recontact_invitation.token)
      assert_redirected_to survey_onramp_url(@onramp.token, uid: @recontact_invitation.token)

      assert_difference -> { Onboarding.count } do
        follow_redirect!
      end

      onboarding = Onboarding.where(onramp: @onramp).order(:created_at).last
      assert_redirected_to new_survey_step_check_url(onboarding.next_traffic_step_or_analyze.token)
    end
  end
end
