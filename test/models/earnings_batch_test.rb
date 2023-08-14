# frozen_string_literal: true

require 'test_helper'

class EarningsBatchTest < ActiveSupport::TestCase
  describe 'fixture' do
    setup { @earning_batch = earnings_batches(:one) }

    it 'is valid' do
      @earning_batch.valid?
      assert_empty @earning_batch.errors
    end
  end
end
