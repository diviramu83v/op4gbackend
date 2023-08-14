# frozen_string_literal: true

require 'test_helper'

class Employee::AffiliatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:recruitment)
    sign_in(@employee)
  end

  describe '#index' do
    test 'load the page' do
      get affiliates_url

      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @affiliate = affiliates(:one)
    end

    test 'load the page' do
      get affiliate_url(@affiliate)

      assert_response :ok
    end
  end
end
