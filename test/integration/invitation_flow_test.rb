# frozen_string_literal: true

require 'test_helper'

class InvitationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @invitation = project_invitations(:standard)
    @invitation.sent!
    @invitation.query.add_onramp

    Panelist.any_instance.stubs(:start_conversions_job).returns(true)
    confirm_panelist!(@invitation.panelist)
    Panelist.any_instance.expects(:demos_completed?).returns(true).once

    load_and_sign_in_panelist(@invitation.panelist)
  end

  describe 'invitation flow' do
    setup do
      @onramp = @invitation.survey.onramp_for_panel(@invitation.batch.panel)
    end

    it 'connects to the appropriate panelist, onramp, and onboarding record' do
      get invitation_url(@invitation.token)
      assert_redirected_to survey_onramp_url(@onramp.token, uid: @invitation.token)

      assert_difference -> { Onboarding.count } do
        follow_redirect!
      end
      onboarding = Onboarding.where(onramp: @onramp).order(:created_at).last
      assert_redirected_to new_survey_step_check_url(onboarding.next_traffic_step_or_analyze.token)

      assert_not_nil onboarding.panel
      assert_equal @invitation.panel, onboarding.panel

      assert_not_nil onboarding.invitation
      assert_equal @invitation, onboarding.invitation

      assert_not_nil onboarding.panelist
      assert_equal @panelist, onboarding.panelist
      assert_equal @invitation.panelist, onboarding.panelist
    end
  end
end
