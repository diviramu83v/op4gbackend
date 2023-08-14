# frozen_string_literal: true

require 'test_helper'

class TangoApiTest < ActiveSupport::TestCase
  setup do
    @incentive_recipient = incentive_recipients(:standard)
  end

  describe '#create order' do
    it 'should create an order' do
      stub_request(:post, 'https://integration-api.tangocard.com/raas/v2/orders').to_return(status: 200)

      assert_equal '', TangoApi.new.create_order(body: {}).body
    end
  end

  describe '#account' do
    it 'should get account' do
      stub_request(:get, 'https://integration-api.tangocard.com/raas/v2/accounts/A85728620').to_return(status: 200)

      assert_nil TangoApi.new.account
    end
  end

  describe '#order data' do
    it 'should return a hash' do
      test = TangoOrderData.new(@incentive_recipient).order_body

      assert_equal test.class, Hash
    end
  end
end
