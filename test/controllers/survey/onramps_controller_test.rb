# frozen_string_literal: true

require 'test_helper'

class Survey::OnrampsControllerTest < ActionDispatch::IntegrationTest
  describe 'GET /' do
    setup do
      @survey = setup_live_survey
      @onramp = onramps(:panel)
      @onramp.update!(project: @survey.project, survey: @survey)
    end

    describe 'repeat traffic from same IP address' do
      it 'does not record any events' do
        Onboarding.any_instance.expects(:record_fraud_event).never
        Onboarding.any_instance.expects(:record_suspicious_event).never

        get survey_onramp_url(@onramp.token, uid: 'testing123')
        get survey_onramp_url(@onramp.token, uid: 'testing123')
      end

      it 'is redirected to the survey both times' do
        get survey_onramp_url(@onramp.token, uid: 'testing123')
        @onboarding = Onboarding.last
        assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)

        get survey_onramp_url(@onramp.token, uid: 'testing123')
        @onboarding = Onboarding.last
        assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
      end
    end

    describe 'repeat traffic from a new IP address' do
      it 'records expected event' do
        Onboarding.any_instance.expects(:record_fraud_event).once

        get survey_onramp_url(@onramp.token, uid: 'testing123')

        ActionDispatch::Request.any_instance.stubs(:remote_ip).returns(ip_addresses(:standard).address)

        get survey_onramp_url(@onramp.token, uid: 'testing123')
      end
    end

    describe 'no traffic steps exist for onboarding' do
      it 'should redirect to bad request url' do
        get survey_onramp_url(@onramp.token, uid: 'testing123')
        Onboarding.find_by(uid: 'testing123').traffic_steps.destroy_all
        get survey_onramp_url(@onramp.token, uid: 'testing123')
        assert_redirected_to bad_request_url
      end
    end

    describe 'bad onramp token' do
      it 'redirects to the error page' do
        get survey_onramp_url('0.5637448976659163', uid: 'testing123')
        assert_redirected_to survey_error_url

        get survey_onramp_url('badtoken123', uid: 'testing123')
        assert_redirected_to survey_error_url
      end
    end

    describe 'blank uid' do
      it 'redirects to the error page' do
        get survey_onramp_url(@onramp.token, uid: '')
        assert_redirected_to survey_error_url
      end
    end

    describe 'test link' do
      it 'redirects to the error page without an employee' do
        get survey_onramp_url(@onramp.token, uid: 'test_link')
        assert_redirected_to survey_error_url
      end

      it 'redirects to the next survey step with employee' do
        load_and_sign_in_operations_employee
        get survey_onramp_url(@onramp.token, uid: 'test_link')
        @onboarding = Onboarding.last
        assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
      end
    end

    describe 'overquota' do
      setup do
        Onramp.any_instance.expects(:disabled?).returns(true)
      end

      describe 'vendor batch overquota url' do
        setup do
          vendor_batch = Minitest::Mock.new
          vendor_batch.expect(:try, 'some_url/', [:overquota_url])
          vendor_batch.expect(:overquota_url, 'some_url/')
          Onramp.any_instance.expects(:vendor_batch).twice.returns(vendor_batch)
        end

        it 'checks for overquota_url' do
          get survey_onramp_url(@onramp.token, uid: 'testing123')
          assert_redirected_to('some_url/testing123')
        end
      end

      describe 'no vendor batch' do
        it 'checks for overquota_url' do
          get survey_onramp_url(@onramp.token, uid: 'testing123')
          assert_redirected_to(survey_full_url)
        end
      end
    end
  end

  it 'success' do
    @onramp = onramps(:vendor)
    @onramp.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")

    assert_difference -> { Onboarding.count }, 1 do
      get survey_onramp_url(@onramp.token, uid: 'testing123')
    end
    @onboarding = Onboarding.last

    assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
  end

  it 'panel onboardings are attached to an invitation' do
    load_and_sign_in_confirmed_panelist
    @sample_batch = sample_batches(:standard)
    @sample_batch.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")
    @onramp = onramps(:panel)
    @onramp.update!(survey: @sample_batch.survey)

    @survey = @sample_batch.survey
    @sample_batch.send_invitations @employee
    @invitation = @panelist.invitations.find_by(survey: @survey)

    assert_difference -> { Onboarding.count }, 1 do
      get survey_onramp_url(@onramp.token, uid: @invitation.token)
    end
    @onboarding = Onboarding.last

    assert_equal @invitation, @onboarding.invitation
  end

  it 'panel onboardings are attached to a panelist' do
    load_and_sign_in_confirmed_panelist
    @onramp = onramps(:panel)
    @sample_batch = sample_batches(:standard)

    @survey = @sample_batch.survey
    @onramp.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")
    @sample_batch.send_invitations @employee
    @invitation = @panelist.invitations.find_by(survey: @survey)

    assert_difference -> { Onboarding.count }, 1 do
      get survey_onramp_url(@onramp.token, uid: @invitation.token)
    end
    @onboarding = Onboarding.last

    assert_equal @panelist, @onboarding.panelist
  end

  it 'panel onboardings are attached to a verified panelist' do
    load_and_sign_in_confirmed_panelist
    @panelist.verified_flag = true
    @onramp = onramps(:panel)
    @sample_batch = sample_batches(:standard)

    @survey = @sample_batch.survey
    @onramp.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")
    @sample_batch.send_invitations @employee
    @invitation = @panelist.invitations.find_by(survey: @survey)

    assert_difference -> { Onboarding.count }, 1 do
      get survey_onramp_url(@onramp.token, uid: @invitation.token)
    end
    @onboarding = Onboarding.last

    assert_equal @panelist, @onboarding.panelist
    assert @panelist.verified?
    assert_equal @onboarding.security_status, 'verified'
  end

  # rubocop:disable Rails::SkipsModelValidations
  it 'non-employee hitting onramp when no survey link is ready sees error' do
    @onramp = onramps(:vendor)
    @onramp.survey.update_columns(base_link: nil)

    get survey_onramp_url(@onramp.token, uid: 'testing123')

    assert_redirected_to survey_error_url
  end
  # rubocop:enable Rails::SkipsModelValidations

  it 'only create onboarding the first time per onramp' do
    @onramp = onramps(:vendor)
    @onramp.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")

    assert_difference -> { Onboarding.count }, 1 do
      get survey_onramp_url(@onramp.token, uid: 'testing123')
    end
    @onboarding = Onboarding.last

    assert_no_difference -> { Onboarding.count } do
      get survey_onramp_url(@onramp.token, uid: 'testing123')
    end

    assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
  end

  it 'can use the same uid on two different onramps for the same project' do
    @panel_onramp = onramps(:panel)
    @panel_onramp.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")
    @external_onramp = onramps(:vendor)
    @external_onramp.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")

    assert_difference -> { Onboarding.count }, 1 do
      get survey_onramp_url(@panel_onramp.token, uid: 'testing123')
    end

    assert_difference -> { Onboarding.count }, 1 do
      get survey_onramp_url(@external_onramp.token, uid: 'testing123')
    end
  end

  it 'valid bypass key sets onboarding flag' do
    @onramp = onramps(:vendor)
    @onramp.survey.update!(base_link: "#{Faker::Internet.url}?pid={{uid}}")

    get survey_onramp_url(@onramp.token, uid: 'testing123', bypass: @onramp.bypass_token)
    @onboarding = Onboarding.last

    assert_not_nil @onboarding.bypassed_security_at
  end

  it 'invalid bypass key is ignored' do
    @onramp = onramps(:vendor)

    get survey_onramp_url(@onramp.token, uid: 'testing123', bypass: 'fail')
    @onboarding = Onboarding.last

    assert_nil @onboarding.bypassed_security_at
  end

  it 'project on hold: redirect to the hold page' do
    Survey.any_instance.stubs(:on_hold?).returns(true)
    @onramp = onramps(:vendor)

    get survey_onramp_url(@onramp.token, uid: 'testing123')

    assert_redirected_to survey_hold_url
  end

  # rubocop:disable Rails::SkipsModelValidations
  it 'disabled onramp with no redirect' do
    @onramp = onramps(:vendor)
    @onramp.batch_vendor.update_columns(complete_url: nil, terminate_url: nil, overquota_url: nil)
    @onramp.disable!
    @onramp.reload

    assert_nil @onramp.batch_vendor.overquota_url
    assert_nil @onramp.vendor_batch.overquota_url

    get survey_onramp_url(@onramp.token, uid: 'testing123')

    assert_redirected_to survey_full_url
  end
  # rubocop:enable Rails::SkipsModelValidations

  it 'disabled onramp with vendor redirect' do
    @onramp = onramps(:vendor)
    @onramp.batch_vendor.update!(overquota_url: 'http://vendor.com/overquota-test?uid=', complete_url: 'http://vendor.com/complete-test?uid=', terminate_url: 'http://vendor.com/terminate-test?uid=')
    @onramp.disable!

    assert_not_nil @onramp.batch_vendor.overquota_url
    assert_nil @onramp.vendor_batch[:overquota_url]

    get survey_onramp_url(@onramp.token, uid: 'testing123')

    assert_redirected_to 'http://vendor.com/overquota-test?uid=testing123'
  end

  # rubocop:disable Rails::SkipsModelValidations
  it 'disabled onramp with vendor batch redirect' do
    @onramp = onramps(:vendor)
    @onramp.batch_vendor.update_columns(complete_url: nil, terminate_url: nil, overquota_url: nil)
    @onramp.vendor_batch.update!(
      complete_url: 'http://vendorbatch.com/complete-test?uid=',
      terminate_url: 'http://vendorbatch.com/terminate-test?uid=',
      overquota_url: 'http://vendorbatch.com/overquota-test?uid='
    )
    @onramp.disable!

    assert_nil @onramp.batch_vendor.overquota_url
    assert_not_nil @onramp.vendor_batch.overquota_url

    get survey_onramp_url(@onramp.token, uid: 'testing123')

    assert_redirected_to 'http://vendorbatch.com/overquota-test?uid=testing123'
  end
  # rubocop:enable Rails::SkipsModelValidations

  it 'disabled onramp with both vendor and vendor batch redirects' do
    @onramp = onramps(:vendor)
    @onramp.vendor_batch.update!(
      complete_url: 'http://vendorbatch.com/complete-test?uid=',
      terminate_url: 'http://vendorbatch.com/terminate-test?uid=',
      overquota_url: 'http://vendorbatch.com/overquota-test?uid='
    )
    @onramp.disable!

    assert_not_nil @onramp.vendor_batch.overquota_url
    assert_not_nil @onramp.vendor_batch.overquota_url

    get survey_onramp_url(@onramp.token, uid: 'testing123')

    assert_redirected_to 'http://vendorbatch.com/overquota-test?uid=testing123'
  end

  it 'error: no uid provided' do
    @onramp = onramps(:vendor)

    assert_no_difference -> { Onboarding.count } do
      get survey_onramp_url(@onramp.token)
    end

    assert_redirected_to survey_error_url
  end

  it 'tests the link' do
    @employee = employees(:operations)
    sign_in(@employee)

    @onramp = onramps(:vendor)
    get survey_onramp_url(@onramp.token, uid: 'test_link')
    assert_equal Onboarding.last.uid, "#{@employee.initials.downcase}_test_1"
  end
end
