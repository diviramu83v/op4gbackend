# frozen_string_literal: true

require 'test_helper'

class Survey::HoldsControllerTest < ActionDispatch::IntegrationTest
  it 'gets the survey holds page' do
    load_and_sign_in_operations_employee

    get survey_hold_url

    assert_ok_with_no_warning
  end
end
