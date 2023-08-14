# frozen_string_literal: true

require 'test_helper'

class RecontactInvitationBatchTest < ActiveSupport::TestCase
  setup do
    @recontact_invitation_batch = recontact_invitation_batches(:standard)
  end

  describe 'fixture' do
    it 'is valid' do
      @recontact_invitation_batch.valid?
      assert_empty @recontact_invitation_batch.errors
    end

    test 'connection to recontact_invitation' do
      assert_includes @recontact_invitation_batch.recontact_invitations, recontact_invitations(:standard)
    end
  end

  describe 'process_csv_data' do
    setup do
      @onboarding = onboardings(:standard)
      RecontactInvitation.destroy_all
      assert_equal 0, RecontactInvitation.count
      @data = { 'xyz' => 'https://www.testing.com/{{uid}}/{{old_uid}}' }.to_json
      @recontact_invitation_batch.update!(csv_data: @data)
    end

    test 'Does not create a recontact_invitation without an email address present on the matched onboarding or panelist record' do
      assert_no_difference 'RecontactInvitation.count' do
        @recontact_invitation_batch.process_csv_data
      end
    end

    test 'Not decoded!' do
      assert_equal @recontact_invitation_batch.status, 'initialized' do
        @recontact_invitation_batch.process_csv_data
      end
    end

    test 'Creates a recontact_invitation record with an email address present on the matched onboarding, also decoded!' do
      @onboarding.update!(email: 'email@test.com')

      assert_difference 'RecontactInvitation.count' do
        @recontact_invitation_batch.process_csv_data
      end

      assert_equal @recontact_invitation_batch.status, 'decoded' do
        @recontact_invitation_batch.process_csv_data
      end
    end

    test 'Creates recontact_invitation record with an email address present on the panelist record associated with the matched onboarding' do
      @data = { 'abcd' => 'https://www.testing.com/{{uid}}/{{old_uid}}' }.to_json
      @recontact_invitation_batch.update!(csv_data: @data)

      assert_difference 'RecontactInvitation.count' do
        @recontact_invitation_batch.process_csv_data
      end
    end
  end

  describe 'no_valid_ids?' do
    test 'returns false when batch contains a valid uid' do
      assert_equal false, @recontact_invitation_batch.no_valid_ids?
    end

    test 'returns true when batch contains no valid uids' do
      @recontact_invitation_batch.recontact_invitations.delete_all
      @recontact_invitation_batch.update!(encoded_uids: "notvalid\nalsonotvalid")

      assert_equal true, @recontact_invitation_batch.no_valid_ids?
    end
  end

  describe '#invitation_count' do
    test 'method is equal to recontact_invitations.size' do
      assert_equal @recontact_invitation_batch.recontact_invitations.size, @recontact_invitation_batch.invitation_count
    end
  end

  describe '#incentive' do
    setup do
      @recontact_invitation_batch.update!(incentive_cents: 500)
    end

    test 'returns formatted' do
      formatted_incentive = @recontact_invitation_batch.incentive.to_f

      assert_equal 5.0, formatted_incentive
    end
  end

  describe '#sendable?' do
    test 'returns false' do
      assert_equal false, @recontact_invitation_batch.sendable?
    end

    test 'returns true' do
      @recontact_invitation_batch.decoded!
      @recontact_invitation_batch.incentive_cents = 500
      assert_equal true, @recontact_invitation_batch.sendable?
    end
  end
end
