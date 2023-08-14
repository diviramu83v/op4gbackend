# frozen_string_literal: true

require 'test_helper'

class Employee::VendorBlockRateReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vendor = vendors(:batch)
    load_and_sign_in_employee(:operations)
  end

  describe '#show' do
    it 'renders correctly' do
      get vendor_block_rate_report_url(@vendor)

      assert_response :ok
      assert_template :show
    end
  end
end
