# frozen_string_literal: true

require 'test_helper'

class Employee::VendorStatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:admin)
    @onramp = onramps(:vendor)
  end

  describe '#show' do
    it 'exports the csv' do
      get onramp_vendor_stats_url(@onramp, format: :csv)
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end
