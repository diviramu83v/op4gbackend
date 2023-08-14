# frozen_string_literal: true

require 'test_helper'

class CreateIncentiveRecipientsJobTest < ActiveJob::TestCase
  setup do
    @batch = incentive_batches(:standard)
  end

  it 'should create invitation' do
    IncentiveRecipient.delete_all
    assert_equal 0, @batch.incentive_recipients.count
    CreateIncentiveRecipientsJob.perform_now(@batch)

    assert_equal 1, @batch.incentive_recipients.count
  end
end
