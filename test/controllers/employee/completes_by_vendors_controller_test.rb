# frozen_string_literal: true

require 'test_helper'

class Employee::CompletesByVendorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#new' do
    it 'should load the page' do
      get new_completes_by_vendors_url

      assert_response :ok
    end
  end
end
