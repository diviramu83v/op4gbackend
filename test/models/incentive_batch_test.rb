# frozen_string_literal: true

require 'test_helper'

class IncentiveBatchTest < ActiveSupport::TestCase
  setup do
    @incentive_batch = incentive_batches(:standard)
  end

  describe '#total_cost' do
    it 'calculates total reward cost for the batch' do
      assert_equal @incentive_batch.total_cost, 100.0
    end

    it 'calculates total reward cost for the batch, doubles when adding a second recipient' do
      @incentive_batch.incentive_recipients.create!(incentive_batch: @incentive_batch,
                                                    first_name: 'Test',
                                                    last_name: 'User',
                                                    email_address: 'test@test.com')
      assert_equal @incentive_batch.total_cost, 200.0
    end
  end
end
