# frozen_string_literal: true

require 'test_helper'

class Panelist::AccountControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist_with_base_info
  end

  it 'should get the panelist account page' do
    get account_url

    assert_redirected_with_no_warning
  end

  it 'should get the demographics page' do
    get account_demographics_url

    assert_response :success
  end

  # it 'should get the `Notification Preferences` page' do
  #   get account_notification_preferences_url

  #   assert_response :success
  # end

  it 'should get the private info page' do
    get edit_account_private_url

    assert_response :success
  end

  it 'should get the earnings page' do
    get account_payments_url

    assert_response :success
  end

  it 'should get the account deletion page' do
    get account_giveup4good_url

    assert_response :success
  end
end
