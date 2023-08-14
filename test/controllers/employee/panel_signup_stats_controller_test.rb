# frozen_string_literal: true

require 'test_helper'

class Employee::PanelSignupStatsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  test 'should get show' do
    panel = panels(:standard)
    get panel_stats_url(panel)
    assert_response :success
  end
end
