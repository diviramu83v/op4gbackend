# frozen_string_literal: true

require 'test_helper'

class Employee::ReturnKeysControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    load_and_sign_in_admin
  end

  describe '#show' do
    it 'should load the page' do
      get reporting_dashboard_url

      assert_response :ok
    end
  end
end
