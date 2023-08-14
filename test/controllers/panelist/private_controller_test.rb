# frozen_string_literal: true

require 'test_helper'

class Panelist::PrivateControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist

    @panelist.update!(encrypted_password: '$2a$12$dD39dDxVtAXmSxApU3NJZuqcvRQVffk2TKTciXI.2c.ltXgzjxf6G')
  end

  it 'should get private // change password page' do
    get edit_account_private_url

    assert_ok_with_no_warning
  end

  it 'should successfully update the password if it matches the password confirmation' do
    post account_private_url, params: { panelist: { current_password: 'RKSv-JT9oVW3nYpnOQkcVQ', new_password: 'test1234', password_confirmation: 'test1234' } }

    assert_redirected_to edit_account_private_url
  end

  it 'should render show with a warning if the current password is not correct' do
    post account_private_url, params: { panelist: { current_password: 'bad_password', new_password: 'test1234', password_confirmation: 'test1234' } }

    assert_not_nil flash[:alert]
    assert_template :edit
  end

  it 'should render show with a warning if the new password does not match the password confirm' do
    post account_private_url, params: { panelist: { current_password: 'RKSv-JT9oVW3nYpnOQkcVQ', new_password: 'test1234', password_confirmation: 'test1235' } }

    assert_not_nil flash[:alert]
    assert_template :edit
  end

  it 'should render show with a warning if the new password is not at least 8 charaters long' do
    post account_private_url, params: { panelist: { current_password: 'RKSv-JT9oVW3nYpnOQkcVQ', new_password: 'test123', password_confirmation: 'test123' } }

    assert_not_nil flash[:alert]
    assert_template :edit
  end
end
