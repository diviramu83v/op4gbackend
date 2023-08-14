# frozen_string_literal: true

require 'test_helper'

# Survey response endpoint is intentionally not secured.
class Survey::ResponsesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  it 'success: record response type' do
    @onboarding = onboardings(:standard)
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns(@onboarding.ip_address.address)

    @onboarding.record_onboarding_completion
    @survey_response = @onboarding.project.complete_response

    assert_not_nil @onboarding.survey_started_at

    assert_no_difference -> { RedirectLog.count } do
      get survey_response_url(@survey_response, uid: @onboarding.token)
    end

    assert_not_equal request.original_url, RedirectLog.last.url

    @onboarding.reload

    assert_equal @onboarding.survey_response_url, @survey_response
  end

  it 'success: record project status' do
    @onboarding = onboardings(:standard)
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns(@onboarding.ip_address.address)

    @onboarding.record_onboarding_completion
    @survey_response = @onboarding.project.complete_response
    @project = @onboarding.project

    assert_not_nil @onboarding.survey_started_at

    assert_no_difference -> { RedirectLog.count } do
      get survey_response_url(@survey_response, uid: @onboarding.token)
    end

    assert_not_equal request.original_url, RedirectLog.last.url
  end

  it 'success: record survey finish time' do
    @onboarding = onboardings(:standard)
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns(@onboarding.ip_address.address)

    @onboarding.record_onboarding_completion
    @survey_response = @onboarding.project.complete_response

    assert_nil @onboarding.survey_finished_at
    assert_not_nil @onboarding.survey_started_at

    get survey_response_url(@survey_response, uid: @onboarding.token)
    @onboarding.reload

    assert_not_nil @onboarding.survey_finished_at
  end

  describe 'complete response' do
    describe 'vendor traffic' do
      setup do
        IpAddress.expects(:find_or_create).returns(ip_addresses(:standard)).once

        @onboarding = onboardings(:standard)
        @onboarding.update!(onramp: onramps(:vendor))
        @onboarding.record_onboarding_completion

        assert_no_enqueued_jobs
      end

      describe 'redirects enabled' do
        setup do
          @onboarding.vendor.update!(disable_redirects: false)
        end

        describe 'complete webhook turned on' do
          setup do
            @onboarding.vendor.update!(send_complete_webhook: true, complete_webhook_url: 'https://batch.vendor.com/webhook?uid=')
          end

          test 'creates vendor notification job' do
            assert_enqueued_with(job: VendorNotificationJob) do
              get survey_response_url(@onboarding.project.complete_response, uid: @onboarding.token)
            end
            assert_enqueued_jobs 1
          end
        end

        describe 'complete webhook turned off' do
          setup do
            @onboarding.vendor.update!(complete_webhook_url: nil)
          end

          test 'does not create a job' do
            get survey_response_url(@onboarding.project.complete_response, uid: @onboarding.token)
            assert_no_enqueued_jobs
          end
        end
      end

      describe 'redirects disabled' do
        setup do
          @onboarding.vendor.update!(disable_redirects: true)
        end

        describe 'complete webhook turned on' do
          setup do
            @onboarding.vendor.update!(send_complete_webhook: true, complete_webhook_url: 'https://batch.vendor.com/webhook?uid=')
          end

          test 'creates vendor notification job' do
            assert_enqueued_with(job: VendorNotificationJob) do
              get survey_response_url(@onboarding.project.complete_response, uid: @onboarding.token)
            end
            assert_enqueued_jobs 1
          end
        end

        describe 'complete webhook turned off' do
          setup do
            @onboarding.vendor.update!(complete_webhook_url: nil)
          end

          test 'redirects to the default complete page' do
            assert_no_difference -> { RedirectLog.count } do
              get survey_response_url(@onboarding.project.complete_response, uid: @onboarding.token)
            end

            assert_not_equal request.original_url, RedirectLog.last.url

            assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
          end

          test 'does not create a job' do
            get survey_response_url(@onboarding.project.complete_response, uid: @onboarding.token)
            assert_no_enqueued_jobs
          end
        end
      end
    end

    describe 'disqo traffic soft launch' do
      setup do
        @onboarding = onboardings(:complete)
        @onboarding.update(onramp: onramps(:disqo), status: 'survey_started')
        @disqo_quota = disqo_quotas(:standard)
        @disqo_quota.update_column(:status, 'live') # rubocop:disable Rails/SkipsModelValidations
        stub_disqo_project_and_quota_status_change
      end

      it 'should pause disqo quota when soft launch limit is reached' do
        @disqo_quota.update_column(:soft_launch_completes_wanted, 1) # rubocop:disable Rails/SkipsModelValidations
        assert_not @disqo_quota.paused?
        get survey_response_url(@onboarding.project.complete_response, uid: @onboarding.token)

        @disqo_quota.reload
        assert @disqo_quota.paused?
      end
    end
  end

  it 'if response is without uid it will redirect to survey error url and not create a redirect log' do
    load_and_sign_in_operations_employee
    response = survey_response_urls(:complete)

    assert_not_nil @employee

    assert_no_difference -> { RedirectLog.count } do
      get survey_response_url(response)
    end

    assert_not_equal request.original_url, RedirectLog.last.url

    assert_redirected_to survey_error_url
  end

  it 'will throw a suspicious:token-error if the onboarding is missing' do
    load_and_sign_in_operations_employee

    response = survey_response_urls(:complete)

    assert_difference -> { RedirectLog.count } do
      get survey_response_url(response, uid: 'anything')
    end

    assert_equal request.original_url, RedirectLog.last.url

    assert_redirected_to survey_error_url
  end

  describe 'return keys on' do
    setup do
      load_return_key_variables
    end

    test 'should create return_key_onboarding / valid token' do
      assert_difference -> { @onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @onboarding.token, token: @response.token, key: @return_key.token)
      end
    end

    test 'should not create return_key_onboarding / missing return key' do
      assert_no_difference -> { @onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @onboarding.token, token: @response.token)
      end
    end

    test 'should not create return_key_onboarding / invalid return key' do
      assert_no_difference -> { @onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @onboarding.token, token: @response.token, key: 'InvalidReturnKey')
      end
    end

    test 'should create return_key_onboarding / repeat return key with a different UID' do
      @onboarding.return_key_onboardings.create!(return_key: @return_key)
      assert_difference -> { @second_onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @second_onboarding.token, token: @response.token, key: @return_key.token)
      end
    end

    test 'should create return_key_onboarding / repeat return key with same UID' do
      @onboarding.return_key_onboardings.create!(return_key: @return_key)
      assert_difference -> { @onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @onboarding.token, token: @response.token, key: @return_key.token)
      end
    end

    test 'should not create return_key_onboarding / return key parameter present, but invalid (return key does not exist)' do
      assert_no_difference -> { @onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @onboarding.token, token: @response.token, key: 'InvalidKey')
      end
    end

    test 'should create return_key_onboarding / return key parameter present, but belongs to a different survey' do
      @second_return_key = return_keys(:three)
      assert_difference -> { @onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @onboarding.token, token: @response.token, key: @second_return_key.token)
      end
    end
  end

  describe 'return keys off' do
    test 'should not create return_key_onboarding / survey does not use return keys' do
      load_return_key_variables
      @survey.return_keys.delete_all
      assert_no_difference -> { @onboarding.return_key_onboardings.count } do
        get survey_response_url(uid: @onboarding.token, token: @response.token, key: @return_key.token)
      end
    end
  end

  private

  def load_return_key_variables
    @onboarding = onboardings(:standard)
    @second_onboarding = onboardings(:second)
    @response = survey_response_urls(:complete)
    @project = @onboarding.project
    @survey = @onboarding.survey
    @return_key = return_keys(:one)
    @survey.return_keys << @return_key
  end
end
