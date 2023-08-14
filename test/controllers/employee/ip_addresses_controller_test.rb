# frozen_string_literal: true

require 'test_helper'

class Employee::IpAddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:security)
    @ip_address = ip_addresses(:standard)
  end

  describe '#index' do
    it 'responds successfully' do
      get ip_addresses_url(context: 'onboarding')

      assert_response :ok
    end

    it 'responds successfully' do
      get ip_addresses_url(context: 'panelist')

      assert_response :ok
    end

    it 'redirects' do
      get ip_addresses_url(context: 'not_onboarding_or_panelist')

      assert_response :redirect
    end
  end

  describe '#show' do
    it 'responds successfully' do
      get ip_address_url(@ip_address)

      assert_response :ok
    end
  end
end
