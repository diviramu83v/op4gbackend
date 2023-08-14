# frozen_string_literal: true

require 'test_helper'

class ApiCintControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  test 'should get index' do
    get api_cint_index_url
    assert_response :success
  end
end
