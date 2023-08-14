# frozen_string_literal: true

require 'test_helper'

class Employee::ScreenExpansionsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
  end

  it 'creates a screen expansion' do
    post screen_expansion_url

    assert_redirected_to employee_dashboard_url
  end

  it 'deletes a screen expansion' do
    delete screen_expansion_url

    assert_redirected_to employee_dashboard_url
  end
end
