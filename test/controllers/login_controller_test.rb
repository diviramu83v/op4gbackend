# frozen_string_literal: true

require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  it 'shouldn\'t be able to hit panelist dashboard without logging in' do
    get panelist_dashboard_url

    assert_panelist_signin_required
  end

  it 'should get panelist dashboard after logging in' do
    load_and_sign_in_confirmed_panelist

    get new_panelist_session_url

    assert_panelist_already_signed_in
  end

  it 'shouldn\'t be able to hit employee dashboard without logging in' do
    get operations_dashboard_url

    assert_employee_signin_required
  end

  it 'should get employee dashboard after logging in' do
    load_and_sign_in_operations_employee

    get new_employee_session_url

    assert_employee_already_signed_in
  end

  it 'shouldn\'t be able to hit admin dashboard without logging in as an admin' do
    get admin_dashboard_url

    assert_employee_signin_required
  end

  it 'should get admin dashboard after logging in as an admin' do
    load_and_sign_in_admin

    get new_employee_session_url

    assert_employee_already_signed_in
  end
end
