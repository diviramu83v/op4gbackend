# frozen_string_literal: true

require 'test_helper'

class Admin::ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_employee = employees(:admin)
    sign_in @admin_employee
  end

  it 'shows the index view' do
    get reports_url

    assert_response :ok
    assert_template :show
  end
end
