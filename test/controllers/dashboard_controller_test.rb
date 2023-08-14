# frozen_string_literal: true

require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  it 'should get index' do
    load_and_sign_in_admin

    get dashboard_url

    assert_ok_with_no_warning
  end
end
