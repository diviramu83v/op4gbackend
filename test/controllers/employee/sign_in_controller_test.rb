# frozen_string_literal: true

require 'test_helper'

class SignInControllerTest < ActionDispatch::IntegrationTest
  it 'should authenticate successfully during a POST' do
    employee = employees(:operations)
    employee.update(password: 'testing123')

    post employee_session_url, params: { employee: { email: employee.email, password: 'testing123' } }

    assert_equal(flash[:notice], 'Signed in successfully.')
  end
end
