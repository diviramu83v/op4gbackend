# frozen_string_literal: true

require 'test_helper'

class RecontactInvitationTest < ActiveSupport::TestCase
  describe 'fixture' do
    describe 'standard' do
      setup do
        @recontact_invitation = recontact_invitations(:standard)
      end

      it 'is valid' do
        @recontact_invitation.valid?
        assert_empty @recontact_invitation.errors
      end

      it 'is connected to the right traffic record' do
        @recontact_invitation.original_onboarding = onboardings(:standard)
        @recontact_invitation.uid = onboardings(:standard).uid
      end
    end
  end
end
