# frozen_string_literal: true

require 'test_helper'

class Employee::SendIncentiveBatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @incentive_batch = incentive_batches(:standard)
    @incentive_batch.employee = employees(:operations)
    @incentive_batch.waiting!
  end

  describe '#create' do
    it 'should enqueue job' do
      TangoApi.any_instance.stubs(:account).returns(200)
      assert @incentive_batch.waiting?
      post incentive_batch_sends_url(@incentive_batch)

      @incentive_batch.reload
      assert @incentive_batch.sent?
    end

    it 'should enqueue job' do
      TangoApi.any_instance.stubs(:account).returns(200)
      assert_no_enqueued_jobs

      assert_enqueued_with(job: CreateTangoOrdersJob) do
        post incentive_batch_sends_url(@incentive_batch)
      end

      assert_enqueued_jobs 1
    end

    it 'should flash alert' do
      IncentiveBatch.any_instance.stubs(:account_balance_enough?).returns(false)
      post incentive_batch_sends_url(@incentive_batch)

      assert_equal 'Not enough funds in the account to fulfill order', flash[:alert]
    end
  end
end
