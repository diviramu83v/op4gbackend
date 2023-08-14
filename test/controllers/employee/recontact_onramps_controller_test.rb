# frozen_string_literal: true

require 'test_helper'

class Employee::RecontactOnrampsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @recontact = surveys(:standard)
  end

  test 'recontact onramps page' do
    get recontact_onramps_url(@recontact)
    assert_response :ok
  end
end
