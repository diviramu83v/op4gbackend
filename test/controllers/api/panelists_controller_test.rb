# frozen_string_literal: true

require 'test_helper'

class Api::PanelistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @token = api_tokens(:standard)
    @panelist_params = {
      panelist: {
        first_name: 'panelist',
        last_name: 'lname-test',
        email: 'panelist@test.com',
        password: 'password',
        code: 'any-code',
        panel: 'op4g-us'
      }
    }
  end

  describe '#create' do
    it 'successfully creates the panelist' do
      assert_difference -> { Panelist.count }, 1 do
        post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }
      end

      assert_response :created

      @panelist = Panelist.last
      assert_match 'panelist', @panelist.first_name
      assert_match 'panelist@test.com', @panelist.email

      body = JSON.parse(response.body)
      assert_equal 201, body['status']
    end

    it 'does not create the panelist if missing any of the required params' do
      @panelist_params = {
        panelist: {
          first_name: 'panelist',
          last_name: 'lname-test',
          email: 'panelist@test.com',
          password: 'password',
          panel: 'op4g-us'
        }
      }

      post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :bad_request

      body = JSON.parse(response.body)
      assert_equal 400, body['status']
      assert_equal 'Missing required attributes.', body['error']

      @panelist2 = {
        panelist: {
          first_name: 'panelist',
          last_name: 'lname-test',
          email: 'panelist@test.com',
          password: 'password',
          code: 'any-code'
        }
      }

      post v1_panelists_url, params: @panelist2, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :bad_request

      body = JSON.parse(response.body)
      assert_equal 400, body['status']
      assert_equal 'Missing required attributes.', body['error']
    end

    it 'returns an error with an invalid panel code' do
      @panelist_params = {
        panelist: {
          first_name: 'panelist',
          last_name: 'lname-test',
          email: 'panelist@test.com',
          password: 'password',
          code: 'any-code',
          panel: 'bad-panel-code'
        }
      }

      post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :bad_request

      body = JSON.parse(response.body)
      assert_equal 400, body['status']
      assert_equal 'Invalid attributes.', body['error']
    end

    it 'returns an error with an invalid campaign code' do
      @panelist_params = {
        panelist: {
          first_name: 'panelist',
          last_name: 'lname-test',
          email: 'panelist@test.com',
          password: 'password',
          code: 'bad-campaign-code',
          panel: 'op4g-us'
        }
      }

      post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :bad_request

      body = JSON.parse(response.body)
      assert_equal 400, body['status']
      assert_equal 'Invalid attributes.', body['error']
    end

    it 'does not create a panelist with an email already in the system' do
      @panelist2 = {
        panelist: {
          first_name: 'second',
          last_name: 'panelist',
          email: 'panelist@test.com',
          password: 'password',
          code: 'any-code',
          panel: 'op4g-us'
        }
      }

      post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :created

      post v1_panelists_url, params: @panelist2, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :bad_request

      @panelist = Panelist.last
      assert_not_equal 'second', @panelist.first_name

      body = JSON.parse(response.body)
      assert_equal 400, body['status']
      assert_equal 'Email address has already been used.', body['error']
    end

    it 'variables are passed from params to panelist' do
      post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :created

      @panelist = Panelist.last

      assert_equal 'any-code', @panelist.campaign.code
    end

    it 'successful campaign registration adds panelist to Op4G panel' do
      @panel = Panel.find_by(slug: 'op4g-us')

      assert_difference -> { @panel.panelist_count }, 1 do
        post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }
      end

      assert_response :created

      new_panelist = Panelist.where(email: @panelist_params[:panelist][:email]).first

      assert new_panelist.last_activity_at.present?
    end
  end
end
