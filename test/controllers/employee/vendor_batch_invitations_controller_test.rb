# frozen_string_literal: true

require 'test_helper'

class Employee::VendorBatchInvitationsControllerTest < ActionDispatch::IntegrationTest
  it 'updates the batch when called' do
    load_and_sign_in_operations_employee

    @vendor_batch = vendor_batches(:standard)

    patch vendor_batch_invitations_url(vendor_batch_id: @vendor_batch.id), params: { vendor_batch: @vendor_batch.attributes }

    assert_redirected_to survey_url(@vendor_batch.survey)
  end
end
