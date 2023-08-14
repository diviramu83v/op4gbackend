# frozen_string_literal: true

require 'test_helper'

class Survey::ErrorsControllerTest < ActionDispatch::IntegrationTest
  it 'load the error page' do
    get survey_error_url

    assert_ok_with_no_warning
  end
end
