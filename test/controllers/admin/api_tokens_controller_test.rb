# frozen_string_literal: true

require 'test_helper'

class Admin::ApiTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_employee = employees(:admin)
    sign_in @admin_employee
  end

  it 'displays the token list' do
    get api_tokens_url

    assert_response :ok
    assert_template :index
  end

  describe '#edit' do
    setup do
      @token = api_tokens(:standard)
    end

    it 'should display the edit page' do
      get edit_api_token_url(@token)

      assert_response :ok
    end
  end

  it 'displays the view to create a new token' do
    get new_api_token_url

    assert_response :ok
    assert_template :new
  end

  it 'creates a new token' do
    post api_tokens_url, params: { api_token: { description: 'test description', vendor_id: Vendor.first.id } }

    assert_redirected_to api_tokens_url
  end

  it 'updates a token' do
    @token = api_tokens(:standard)

    put api_token_url(@token), params: { api_token: { status: 'sandbox' } }

    assert_redirected_to api_tokens_url
  end

  it 'deletes a token' do
    @token = api_tokens(:standard)

    assert_difference -> { ApiToken.count }, -1 do
      delete api_token_url(@token)
    end

    assert_redirected_to api_tokens_url
  end
end
