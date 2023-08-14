# frozen_string_literal: true

require 'test_helper'

class Panelist::InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
  end

  describe '#show' do
    it 'invitation click redirects to client link' do
      load_invitation_variables

      @onramp = @survey.onramp_for_panel(@invitation.panel)

      assert @panelist.invited_and_open?(survey: @survey)

      get invitation_url(@invitation.token)

      assert_redirected_to survey_onramp_url(@onramp.token, uid: @invitation.token)
    end

    it 'invitation click records event' do
      load_invitation_variables

      @onramp = @survey.onramp_for_panel(@invitation.panel)

      assert_nil @invitation.clicked_at

      get invitation_url(@invitation.token)
      @invitation.reload

      assert_not_nil @invitation.clicked_at
    end

    it 'rescues invitation error' do
      load_invitation_variables

      @onramp = @survey.onramp_for_panel(@invitation.panel)
      @invitation.update!(status: 'initialized')

      get invitation_url(@invitation.token)

      assert_redirected_to panelist_dashboard_url
    end

    it 'attempt uninvited survey' do
      assert_not @panelist.invited_and_open?(survey: @survey)

      get invitation_url('random-fake-token')

      assert_redirected_to panelist_dashboard_url
    end

    it 'attempt survey intended for someone else' do
      @panelist.invitations.destroy_all
      @invited_panelist = panelists(:active)

      @sample_batch = sample_batches(:standard)
      @survey = @sample_batch.survey
      @sample_batch.create_invitation(@invited_panelist.id)
      @sample_batch.send_invitations @employee

      @invited_panelist_invitation = @invited_panelist.invitations.find_by(survey: @survey)
      assert_not_nil @invited_panelist_invitation
      @invited_panelist_invitation.sent!

      assert_not @panelist.invited_and_open?(survey: @survey)
      assert @invited_panelist.invited_and_open?(survey: @survey)

      get invitation_url(@invited_panelist_invitation.token)

      assert_redirected_to panelist_dashboard_url
    end

    it 'attempt full survey' do
      # Fake full survey.
      ProjectInvitation.any_instance.stubs(:closed?).returns(true)

      load_invitation_variables

      assert @panelist.invited_and_open?(survey: @survey)

      get invitation_url(@invitation.token)

      assert_redirected_to panelist_dashboard_url
    end

    it 'attempt closed invitation' do
      load_invitation_variables

      assert @panelist.invited_and_open?(survey: @survey)
      @sample_batch.close
      assert_not @panelist.invited_and_open?(survey: @survey)

      get invitation_url(@invitation.token)

      assert_redirected_to panelist_dashboard_url
    end

    it 'updates the panelist\'s last_activity_at timestamp for stale panelist calculations' do
      load_invitation_variables

      assert @panelist.invited_and_open?(survey: @survey)
      assert @panelist.last_activity_at.nil?

      @panelist.status = Panelist.statuses[:deactivated]
      @panelist.save!

      assert_equal @panelist.status, 'deactivated'

      get invitation_url(@invitation.token)

      assert @panelist.last_activity_at
      assert_equal @panelist.status, 'active'
    end
  end

  describe '#destroy' do
    it 'updates the declined_at field' do
      invitation = ProjectInvitation.last
      invitation.sent!

      delete invitation_url(invitation)

      assert_not_nil ProjectInvitation.last.declined_at
      assert_redirected_to panelist_dashboard_url
    end
  end

  it 'rescues invitation error' do
    invitation = ProjectInvitation.last

    delete invitation_url(invitation)

    assert_redirected_to panelist_dashboard_url
  end

  private

  def load_invitation_variables
    @sample_batch = sample_batches(:standard)
    @survey = @sample_batch.survey
    @sample_batch.send_invitations @employee
    @invitation = @panelist.invitations.find_by(survey: @survey)
    @invitation.sent!
  end
end
