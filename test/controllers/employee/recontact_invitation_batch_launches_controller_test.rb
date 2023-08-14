# frozen_string_literal: true

require 'test_helper'

class Employee::RecontactInvitationBatchLaunchesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    sign_in employees(:operations)
    @batch = recontact_invitation_batches(:standard)
  end

  describe '#create' do
    it 'should redirect to recontact page' do
      skip_in_ci
      post recontact_invitation_batch_launch_url(@batch)

      assert_redirected_to recontact_url(@batch.survey)
    end

    it 'launches batch' do
      assert_not_empty @batch.recontact_invitations

      assert_enqueued_with(job: SendRecontactBatchInvitationsJob) do
        post recontact_invitation_batch_launch_url(@batch)
      end
    end

    it 'fails to launch batch' do
      skip_in_ci
      RecontactInvitationBatch.any_instance.stubs(:send_invitations).returns(false)

      assert_not_empty @batch.recontact_invitations

      assert_no_enqueued_jobs do
        post recontact_invitation_batch_launch_url(@batch)
      end
    end
  end
end
