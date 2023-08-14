# frozen_string_literal: true

require 'test_helper'

class Employee::PanelPanelistLifecycleStatsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  test 'should get show' do
    panel = panels(:standard)
    get panel_lifecycle_url(panel)
    assert_response :success
  end
end
