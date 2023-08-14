# frozen_string_literal: true

require 'test_helper'

class Employee::ApiVendorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:admin)
    @vendor = vendors(:api)
  end

  describe '#index' do
    it 'should load the vendors page' do
      get api_vendors_url

      assert_response :ok
      assert_template :index
    end
  end

  describe '#show' do
    it 'should load the show page with "all" status' do
      get api_vendor_url(@vendor)
      assert_response :ok
    end

    it 'should load the show page with "live" status' do
      get api_vendor_url(@vendor, status: 'live')
      assert_response :ok
    end

    it 'should load the show page with "finished" status' do
      get api_vendor_url(@vendor, status: 'finished')
      assert_response :ok
    end

    it 'should load the show page with "hold" status' do
      get api_vendor_url(@vendor, status: 'hold')
      assert_response :ok
    end
  end
end
