# frozen_string_literal: true

require 'test_helper'

class Employee::DenylistControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:security)

    ip_address_two = ip_addresses(:second)
    ip_address_two.update(
      blocked_at: Faker::Date.backward(days: 90),
      status: 'blocked',
      category: 'deny-manual',
      address: '1.1.1.2'
    )
    ip_address_three = ip_addresses(:third)
    ip_address_three.update(
      blocked_at: Faker::Date.backward(days: 90),
      status: 'blocked',
      category: 'deny-auto',
      address: '1.1.1.3'
    )
  end

  describe '#show' do
    it 'responds successfully' do
      get denylist_url
      assert_ok_with_no_warning
    end
  end

  describe '#new' do
    it 'responds successfully' do
      get new_denylist_url
      assert_ok_with_no_warning
    end
  end

  describe '#create' do
    it 'adds a denylist record' do
      @params = { ip_address: { address: '1.1.1.4' } }

      assert_difference -> { IpAddress.blocked_manually.count } do
        post denylist_url, params: @params
      end
    end

    it 'skips a denylist record' do
      @params = { ip_address: { address: '1.1.1.2' } }

      assert_no_difference -> { IpAddress.blocked_manually.count } do
        post denylist_url, params: @params
      end
    end

    it 'skips an invalid record' do
      @params = { ip_address: { address: 'not_an_ip' } }

      assert_no_difference -> { IpAddress.blocked_manually.count } do
        post denylist_url, params: @params
      end
    end
  end

  describe '#destroy' do
    it 'removes a denylist entry' do
      assert_difference -> { IpAddress.blocked_manually.count }, -1 do
        delete "#{denylist_url}?ip=1.1.1.2"
      end

      assert_difference -> { IpAddress.blocked_automatically.count }, -1 do
        delete "#{denylist_url}?ip=1.1.1.3"
      end
    end
  end
end
