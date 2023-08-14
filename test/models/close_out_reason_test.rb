# frozen_string_literal: true

require 'test_helper'

class CloseOutReasonTest < ActiveSupport::TestCase
  describe 'fixture' do
    test 'rejected reason is valid' do
      rejected_reason = close_out_reasons(:rejected)
      rejected_reason.valid?
      assert_empty rejected_reason.errors
    end

    test 'fraud reason is valid' do
      fraud_reason = close_out_reasons(:fraud)
      fraud_reason.valid?
      assert_empty fraud_reason.errors
    end
  end
end
