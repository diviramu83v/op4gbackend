# frozen_string_literal: true

require 'test_helper'

class IncentiveRecipientTest < ActiveSupport::TestCase
  setup do
    @incentive_recipient = incentive_recipients(:standard)
  end

  describe '#set_to_sent' do
    it 'sets to sent' do
      assert_equal @incentive_recipient.status, 'initialized'
      assert_equal @incentive_recipient.sent, false

      @incentive_recipient.set_to_sent
      assert_equal @incentive_recipient.status, 'sent'
      assert_equal @incentive_recipient.sent, true
    end
  end
end
