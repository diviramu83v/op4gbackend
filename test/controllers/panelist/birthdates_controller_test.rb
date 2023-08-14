# frozen_string_literal: true

require 'test_helper'

class Panelist::BirthdatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    travel_to '2018-10-25 09:49:06 UTC'

    load_and_sign_in_confirmed_panelist
    @valid_params = { panelist: { year: '1977', month: '12', day: '28' } }
    @invalid_params = { panelist: { birthdate: 'garbage' } }
  end

  teardown { travel_back }

  it 'GET #edit response is successful ' do
    get edit_account_birthdate_url
    assert_response :success
  end

  it 'PATCH #update response redirects with flash given valid params' do
    patch account_birthdate_url, params: @valid_params

    assert_redirected_to edit_account_birthdate_url
    assert_equal 'Account successfully updated.', flash[:notice]
  end

  it 'PATCH #update updates birthdate given valid params' do
    date = Date.parse '1977-12-28'
    assert_not_equal date, @panelist.birthdate

    patch account_birthdate_url, params: @valid_params
    @panelist.reload

    assert_equal date, @panelist.birthdate
  end

  it 'PATCH #update updates age given valid params' do
    assert_changes -> { @panelist.reload.age }, from: 32, to: 40 do
      patch account_birthdate_url, params: @valid_params
    end
  end

  it 'PATCH #update response renders edit template with flash given invalid params' do
    patch account_birthdate_url, params: @invalid_params

    assert_response :success
    assert_equal 'Account could not be updated.', flash.now[:alert]
  end

  it "PATCH #update doesn't update panelist's birthdate given invalid params" do
    assert_no_changes -> { @panelist.reload.birthdate } do
      patch account_birthdate_url, params: @invalid_params
    end
  end
end
