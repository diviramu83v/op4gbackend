# frozen_string_literal: true

require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  describe 'permitted ip address' do
    setup do
      @ip = ip_addresses(:standard)
      @survey = setup_live_survey
      @onramp = @survey.onramps.first

      ActionDispatch::Request.any_instance.stubs(:remote_ip).returns(@ip.address)
    end

    describe 'when creating the ip address as expected' do
      it 'redirects the request as expected' do
        get survey_onramp_url(@onramp.token, uid: 'fake-uid')
        @onboarding = @onramp.onboardings.last

        assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
      end

      it 'increments the request count' do
        assert_difference -> { @ip.request_count } do
          get survey_onramp_url(@onramp.token, uid: 'fake-uid')
          @ip.reload
        end
      end

      it 'does not increment the blocked count' do
        assert_no_difference -> { @ip.blocked_count } do
          get survey_onramp_url(@onramp.token, uid: 'fake-uid')
          @ip.reload
        end
      end
    end

    describe 'when encountering a record not unique error' do
      setup do
        IpAddress.expects(:find_or_create_by).raises(ActiveRecord::RecordNotUnique)
      end

      it 'redirects the request as expected' do
        get survey_onramp_url(@onramp.token, uid: 'fake-uid')
        @onboarding = @onramp.onboardings.last

        assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
      end
    end
  end

  describe '#log_employee_ip' do
    setup do
      load_and_sign_in_operations_employee
    end

    it 'adds employee ip history on request' do
      assert_difference -> { EmployeeIpHistory.count } do
        get denylist_url
      end
    end
  end

  describe 'blocked ip address' do
    setup do
      @ip = ip_addresses(:standard)
      @ip.update(
        blocked_at: Faker::Date.backward(days: 90),
        status: 'blocked',
        category: 'deny-manual'
      )
      @survey = setup_live_survey
      @onramp = @survey.onramps.first

      ActionDispatch::Request.any_instance.stubs(:remote_ip).returns(@ip.address)
    end

    describe 'survey sub-domain' do
      subject { survey_onramp_url(@onramp.token, uid: 'fake-uid') }

      it 'does not redirect to block page' do
        get subject
        @onboarding = Onboarding.last

        assert_redirected_to bad_request_url
      end

      it 'increments the blocked count' do
        assert_difference -> { @ip.blocked_count } do
          get subject
          @ip.reload
        end
      end
    end

    describe 'panelist sub-domain' do
      subject { new_panelist_session_url }

      it 'redirects to block page' do
        get subject
        assert_redirected_to bad_request_url
      end

      it 'increments the blocked count' do
        assert_difference -> { @ip.blocked_count } do
          get subject
          @ip.reload
        end
      end
    end

    describe 'employee sub-domain' do
      subject { new_employee_session_url }

      it 'redirects to block page' do
        get subject
        assert_redirected_to bad_request_url
      end

      it 'increments the blocked count' do
        assert_difference -> { @ip.blocked_count } do
          get subject
          @ip.reload
        end
      end
    end

    describe 'admin sub-domain' do
      before do
        sign_in employees(:admin)
      end

      subject { admin_dashboard_url }

      it 'redirects to block page' do
        get subject
        assert_redirected_to bad_request_url
      end

      it 'increments the blocked count' do
        assert_difference -> { @ip.blocked_count } do
          get subject
          @ip.reload
        end
      end
    end

    describe 'testing sub-domain' do
      setup do
        @survey = setup_live_survey
      end

      subject { test_survey_url(@survey.token) }

      it 'redirects to block page' do
        get subject
        assert_redirected_to bad_request_url
      end

      it 'increments the blocked count' do
        assert_difference -> { @ip.blocked_count } do
          get subject
          @ip.reload
        end
      end
    end
  end

  describe 'authenticity error' do
    setup do
      Panelist::SessionsController.any_instance.stubs(:new).raises(ActionController::InvalidAuthenticityToken).once
    end

    it 'redirects to bad request page' do
      get new_panelist_session_url

      assert_redirected_to bad_request_url
    end

    it 'creates a new activity record for the IP address' do
      IpAddress.any_instance.expects(:record_suspicious_event!)

      get new_panelist_session_url
    end
  end

  describe 'invalid encoding error' do
    setup do
      Panelist::SessionsController.any_instance.stubs(:create).raises(ArgumentError.new('invalid %-encoding (tr*thse%k)')).once
    end

    it 'redirects to bad request page' do
      post panelist_session_url

      assert_redirected_to bad_request_url
    end

    it 'creates a new activity record for the IP address' do
      IpAddress.any_instance.expects(:record_suspicious_event!)

      post panelist_session_url
    end
  end

  describe 'invalid byte sequence error' do
    setup do
      Panelist::SessionsController.any_instance.stubs(:create).raises(ArgumentError.new('invalid byte sequence in UTF-8 ')).once
    end

    it 'redirects to bad request page' do
      post panelist_session_url

      assert_redirected_to bad_request_url
    end

    it 'creates a new activity record for the IP address' do
      IpAddress.any_instance.expects(:record_suspicious_event!)

      post panelist_session_url
    end
  end

  describe 'ActionDispatch::RemoteIp::IpSpoofAttackError' do
    setup do
      ActionDispatch::Request.any_instance.expects(:remote_ip).raises(ActionDispatch::RemoteIp::IpSpoofAttackError).twice
    end

    it 'redirects to bad request page' do
      get new_panelist_session_url
      assert_redirected_to bad_request_url
    end

    it 'blocks both IP addresses involved' do
      IpAddress.expects(:auto_block).twice
      get new_panelist_session_url
    end
  end

  describe 'API token responses' do
    setup do
      @token = api_tokens(:standard)
    end

    it 'returns a valid response for a GET request with a valid token' do
      get v1_surveys_url, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :ok
    end

    it 'returns a message about an invalid token when the token is invalid' do
      get v1_surveys_url, headers: { 'HTTP_AUTHORIZATION' => 'Bearer 123' }

      assert_response :bad_request
      assert response.body.include? 'Invalid token'
    end

    it 'returns a message about an invalid token when the token is missing' do
      get v1_surveys_url

      assert_response :bad_request
      assert response.body.include? 'Invalid token'
    end

    it 'returns a message about an invalid token when the token is missing' do
      get v1_surveys_url

      assert_response :bad_request
      assert response.body.include? 'Invalid token'
    end

    it 'returns a message about an invalid token when the token is blocked' do
      @token.update!(status: :blocked)

      get v1_surveys_url, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :bad_request
      assert response.body.include? 'Invalid token'
    end

    it 'returns a message about an invalid token when the token is rate limited' do
      75.times do
        SystemEvent.create(description: 'description', api_token: @token, happened_at: Time.now.utc)
      end

      get v1_surveys_url, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }

      assert_response :too_many_requests
      assert response.body.include? 'limit reached'
    end

    describe 'POST' do
      setup do
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

      it 'returns a valid response' do
        assert_difference 'Panelist.count' do
          post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }
        end

        assert_response :created
      end

      it 'does not limit the number of requests' do
        75.times do
          SystemEvent.create(description: 'description', api_token: @token, happened_at: Time.now.utc)
        end

        assert_difference 'Panelist.count' do
          post v1_panelists_url, params: @panelist_params, headers: { 'HTTP_AUTHORIZATION' => "Bearer #{@token.token}" }
        end

        assert_response :created
        assert_not response.body.include? 'limit reached'
      end
    end
  end

  describe 'options request' do
    setup do
      # Not sure how else to test an options request.
      ActionDispatch::Request.any_instance.stubs(:method).returns('OPTIONS')
    end

    it 'returns ok' do
      get '/unknown-resource'
      assert_response :ok
    end
  end

  describe 'head request' do
    setup do
      # Not sure how else to test a head request.
      ActionDispatch::Request.any_instance.stubs(:method).returns('HEAD')
    end

    it 'returns ok' do
      head '/unknown-resource'
      assert_response :ok
    end
  end
end
