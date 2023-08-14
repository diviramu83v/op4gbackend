# frozen_string_literal: true

require 'test_helper'

class Employee::IpBlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:security)
    @ip_address = ip_addresses(:standard)
  end

  describe '#create' do
    it 'adds a blocked record' do
      assert_difference -> { IpAddress.blocked_manually.count } do
        post ip_address_ip_block_url(@ip_address), params: { ip_address: { blocked_reason: 'test' } }
      end
    end
  end

  describe '#destroy' do
    it 'removes a blocked record' do
      post ip_address_ip_block_url(@ip_address), params: { ip_address: { blocked_reason: 'test' } }
      assert_difference -> { IpAddress.not_allowed.count }, -1 do
        delete ip_address_ip_block_url(@ip_address)
      end
    end
  end
end
