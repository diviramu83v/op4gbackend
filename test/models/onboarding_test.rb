# frozen_string_literal: true

require 'test_helper'

class OnboardingTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  describe 'fixture' do
    describe 'standard' do
      it 'is valid' do
        onboarding = onboardings(:standard)
        assert onboarding.valid?
        assert_empty onboarding.errors
      end
    end

    describe 'second' do
      it 'is valid' do
        onboarding = onboardings(:second)
        assert onboarding.valid?
        assert_empty onboarding.errors
      end
    end
  end

  describe 'attributes' do
    subject { onboardings(:standard) }

    should have_db_column(:onboarding_token)
  end

  describe 'associations' do
    subject { onboardings(:standard) }

    should belong_to(:ip_address).optional
  end

  describe 'validations' do
    subject { onboardings(:standard) }

    # should validate_presence_of(:ip_address)
  end

  describe '#set_security_status' do
    setup do
      @onboarding = onboardings(:standard)
      @onramp = @onboarding.onramp
    end

    test 'returns other if onramp is a testing onramp' do
      @onboarding.set_security_status
      assert_equal @onboarding.security_status, 'other'
    end

    test 'returns secured' do
      @onramp.stubs(:secured?).returns(true)
      @onramp.update!(category: 'panel', panel: panels(:standard))
      @onboarding.set_security_status
      assert_equal @onboarding.security_status, 'secured'
    end

    test 'returns unsecured' do
      @onramp.stubs(:secured?).returns(false)
      @onramp.update!(category: 'panel', panel: panels(:standard))
      @onboarding.set_security_status
      assert_equal @onboarding.security_status, 'unsecured'
    end

    test 'returns other if bypassed_security_at is present' do
      @onramp.update!(category: 'panel', panel: panels(:standard), check_recaptcha: true, check_clean_id: true)
      @onboarding.update!(bypassed_security_at: Time.now.utc)
      @onboarding.set_security_status
      assert_equal @onboarding.security_status, 'other'
    end

    test 'verified panelist traffic' do
      # setup needed

      assert_equal 'unsecured', @onboarding.security_status
    end
  end

  describe '#record_suspicious_event' do
    setup do
      @onboarding = onboardings(:standard)
    end
    test 'creates suspicious event' do
      assert_difference -> { TrafficEvent.suspicious.count } do
        @onboarding.record_suspicious_event(message: 'message')
      end
    end
  end

  describe '#fraud_detected?' do
    subject { onboardings(:standard) }

    describe 'with fraud timestamp' do
      setup do
        subject.record_fraud_timestamp
      end

      it 'returns true' do
        assert subject.fraud_detected?
      end
    end

    describe 'with fraud event' do
      setup do
        subject.record_fraud_event(message: 'generic fraud message')
      end

      it 'returns true' do
        assert subject.fraud_detected?
      end
    end

    describe 'with no fraud timestamp or fraud events' do
      setup do
        assert_nil subject.fraud_attempted_at
        assert_empty subject.events.fraudulent
      end

      it 'returns false' do
        assert_not subject.fraud_detected?
      end
    end
  end

  describe '#blocked_ip_address?' do
    describe 'with blocked ip address' do
      describe 'ip feature flag on' do
        setup do
          FeatureManager.stubs(:ip_auto_blocking?).returns(true)
          @onboarding = onboardings(:standard)
        end

        it 'returns true' do
          IpAddress.auto_block(address: @onboarding.ip_address.address, reason: 'test')

          @onboarding.reload

          assert @onboarding.blocked_ip_address?
        end
      end

      describe 'ip feature flag off' do
        setup do
          FeatureManager.stubs(:ip_auto_blocking?).returns(false)
          @onboarding = onboardings(:standard)
        end

        it 'returns false' do
          IpAddress.auto_block(address: @onboarding.ip_address.address, reason: 'test')

          @onboarding.reload

          assert_not @onboarding.blocked_ip_address?
        end
      end
    end

    describe 'with a good IP address' do
      setup do
        @onboarding = onboardings(:standard)
        assert_not @onboarding.ip_address.blocked?
      end

      it 'returns false' do
        assert_not @onboarding.blocked_ip_address?
      end
    end
  end

  describe '#record_response' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.update(status: Onboarding.statuses[:survey_started])
    end

    before do
      clear_enqueued_jobs
    end

    it 'enqueues a job with a completed response and a webhook_url' do
      vendor = vendors(:batch)
      vendor.update!(send_complete_webhook: true, complete_webhook_url: 'http://vendor/test-webhook?uid=')
      @onboarding.onramp.update!(category: 'vendor', vendor_batch: VendorBatch.create(vendor: vendor, survey: @onboarding.survey, incentive_cents: 100,
                                                                                      quoted_completes: 300, requested_completes: 300))

      response = survey_response_urls(:complete)
      response.update!(project: @onboarding.project)

      assert_no_enqueued_jobs

      assert_enqueued_with(job: VendorNotificationJob) do
        @onboarding.record_survey_response(response)
      end

      assert_enqueued_jobs 1
    end

    it "doesn't enqueue a job with a completed response and no webhook_url" do
      @onboarding.onramp.update!(category: 'vendor', vendor_batch: vendor_batches(:standard))
      response = survey_response_urls(:complete)
      response.update!(project: @onboarding.project)

      assert_no_enqueued_jobs

      @onboarding.record_survey_response(response)

      assert_no_enqueued_jobs
    end

    it "doesn't enqueue a job with a terminate response and a webhook_url" do
      @onboarding.onramp.update!(category: 'vendor', vendor_batch: vendor_batches(:standard))
      response = survey_response_urls(:terminate)
      response.update!(project: @onboarding.project)

      assert_no_enqueued_jobs
      @onboarding.record_survey_response(response)
      assert_no_enqueued_jobs
    end

    it "doesn't enqueue a job with a quotafull response and a webhook_url" do
      @onboarding.onramp.update!(category: 'vendor', vendor_batch: vendor_batches(:standard))
      response = survey_response_urls(:quotafull)
      response.update!(project: @onboarding.project)

      assert_no_enqueued_jobs
      @onboarding.record_survey_response(response)
      assert_no_enqueued_jobs
    end

    it 'enqueues job with a cint onramp and complete response' do
      stub_request(:post, "#{Settings.cint_api_url}/fulfillment/respondents/transition").to_return(status: 200)
      @onboarding.onramp.update!(category: 'cint')
      response = survey_response_urls(:complete)

      assert_no_enqueued_jobs
      @onboarding.record_survey_response(response)
      assert_enqueued_jobs 1
    end
  end

  describe '#record_fraud_timestamp' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'records the time of the fraudulent attempt' do
      assert_nil @onboarding.fraud_attempted_at
      @onboarding.record_fraud_timestamp
      assert_not_nil @onboarding.fraud_attempted_at
    end
  end

  describe '#never_onboarded?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns true' do
      assert_equal true, @onboarding.never_onboarded?
    end

    it 'returns false' do
      @onboarding.survey_started!
      assert_equal false, @onboarding.never_onboarded?
    end
  end

  describe '#check_for_ip_change' do
    describe 'with a different IP' do
      setup do
        @onboarding = onboardings(:standard)
        @different_ip = ip_addresses(:second)
        assert_not_equal @different_ip.address, @onboarding.ip_address.address
      end

      it 'creates a new fraud event' do
        assert_difference -> { TrafficEvent.fraudulent.count } do
          @onboarding.check_for_ip_change(ip_to_check: @different_ip)
        end
      end
    end

    describe 'with the same IP' do
      setup do
        @onboarding = onboardings(:standard)
        @same_ip = @onboarding.ip_address
        assert_equal @same_ip.address, @onboarding.ip_address.address
      end

      it 'does not create a new fraud event' do
        IpAddress.expects(:auto_block).never

        assert_no_difference -> { TrafficEvent.fraudulent.count } do
          @onboarding.check_for_ip_change(ip_to_check: @same_ip)
        end
      end

      it 'does not create a new suspicious event' do
        IpAddress.expects(:auto_block).never

        assert_no_difference -> { TrafficEvent.suspicious.count } do
          @onboarding.check_for_ip_change(ip_to_check: @same_ip)
        end
      end
    end

    describe 'with no original IP' do
      setup do
        @onboarding = onboardings(:standard)
        @same_ip = @onboarding.ip_address
        @onboarding.update!(ip_address: nil)
      end

      it 'does not create a new fraud event' do
        IpAddress.expects(:auto_block).never

        assert_no_difference -> { TrafficEvent.fraudulent.count } do
          @onboarding.check_for_ip_change(ip_to_check: @same_ip)
        end
      end
    end
  end

  describe '#recaptcha_time_in_seconds' do
    setup do
      @onboarding = onboardings(:standard)
    end

    test 'missing start time' do
      @onboarding.update!(recaptcha_started_at: nil, recaptcha_passed_at: Time.now.utc)
      assert_nil @onboarding.recaptcha_time_in_seconds
    end

    test 'missing end time' do
      @onboarding.update!(recaptcha_started_at: Time.now.utc, recaptcha_passed_at: nil)
      assert_nil @onboarding.recaptcha_time_in_seconds
    end

    test 'calculation' do
      now = Time.now.utc

      @onboarding.update!(recaptcha_started_at: now, recaptcha_passed_at: now + 10.seconds)
      assert_equal 10, @onboarding.recaptcha_time_in_seconds

      @onboarding.update!(recaptcha_started_at: now, recaptcha_passed_at: now + 5.seconds)
      assert_equal 5, @onboarding.recaptcha_time_in_seconds
    end
  end

  describe '#survey_url_with_parameters' do
    setup do
      @onboarding = onboardings(:standard)
      @recontact_invitation = recontact_invitations(:standard)
      @recontact_invitation.update!(token: 123)
      @onboarding.recontact_invitations << @recontact_invitation
      @survey = @onboarding.survey
      onramp = @onboarding.onramp
      onramp.recontact!
    end

    test 'returns correct survey with parameters' do
      assert_equal @onboarding.survey_url_with_parameters,
                   @recontact_invitation.url.gsub('{{uid}}', @onboarding.token).gsub('{{old_uid}}', @recontact_invitation.uid)
    end
  end

  describe '#add_pre_survey_traffic_steps for verified panelist' do
    setup do
      panelist = panelists(:standard)
      panelist.update(verified_flag: true)
      @onboarding = onboardings(:standard)
      @onboarding.update(panelist: panelist, onramp: onramp)
    end
  end

  describe '#add_post_survey_traffic_steps' do
    setup do
      @onboarding = onboardings(:standard)
      @project = @onboarding.project
      @response = survey_response_urls(:complete)
      @panelist = panelists(:standard)
    end

    it 'should not create post traffic steps if the onboarding already has some' do
      assert_no_difference -> { @onboarding.traffic_steps.post_survey.count } do
        @onboarding.add_post_survey_traffic_steps
      end
    end

    it 'should create post traffic steps' do
      @onboarding.traffic_steps.destroy_all
      @onboarding.survey_finished!
      assert_difference -> { @onboarding.traffic_steps.post_survey.count }, 2 do
        @onboarding.add_post_survey_traffic_steps
      end
    end
  end

  describe '#backup_disqo_quota' do
    setup do
      @onboarding = onboardings(:complete)
    end

    it 'returns the first disqo quota that belongs to the survey' do
      assert_equal @onboarding.backup_disqo_quota, @onboarding.survey.disqo_quotas.first
    end
  end

  describe '#cint_source_name' do
    setup do
      @onboarding = onboardings(:complete)
      @cint_survey = cint_surveys(:standard)
    end

    it 'returns the name of the first cint survey that belongs to the survey' do
      assert_equal @onboarding.cint_source_name, "Cint #{@onboarding.survey.cint_surveys.first.name}"
    end

    it 'returns the cint survey name belonging to the onboarding' do
      @onboarding.cint_survey = @cint_survey
      assert_equal @onboarding.cint_source_name, "Cint #{@cint_survey.name}"
    end
  end

  describe '#expert_recruit_email' do
    setup do
      @onboarding = onboardings(:complete)
      @expert_recruit = expert_recruits(:standard)
      @expert_recruit.update!(token: 124)
    end

    it 'returns the expert recruit email' do
      assert_equal @onboarding.expert_recruit_email, @expert_recruit.email
    end
  end

  describe '#complete?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns false' do
      assert_equal false, @onboarding.complete?
    end

    it 'returns true' do
      @onboarding = onboardings(:complete)
      assert_equal true, @onboarding.complete?
    end
  end

  describe '#save_disqo_params' do
    setup do
      @onboarding = onboardings(:standard)
      @params = { clientId: '28377', projectId: '12345', quotaIds: '18829', supplierId: '1111', tid: '100', pid: '200' }
    end

    test 'saves data' do
      @onboarding.save_disqo_params(@params)
      assert_equal '28377', @onboarding.api_params['clientId']
      assert_equal '12345', @onboarding.api_params['projectId']
      assert_equal '18829', @onboarding.api_params['quotaIds']
      assert_equal '1111', @onboarding.api_params['supplierId']
      assert_equal '100', @onboarding.api_params['tid']
      assert_equal '200', @onboarding.api_params['pid']
    end
  end

  describe '#record_cint_response' do
    setup do
      @onboarding = onboardings(:standard)
    end
    test 'Cint onramp' do
      @onboarding.onramp.cint!
      CintPostbackJob.expects(:perform_later).with(onboarding: @onboarding)

      @onboarding.record_cint_response
    end
    test 'non-Cint onramp' do
      CintPostbackJob.expects(:perform_later).with(onboarding: @onboarding).never

      @onboarding.record_cint_response
    end
  end

  describe '#recaptcha_started?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    test 'returns false' do
      assert_equal false, @onboarding.recaptcha_started?
    end

    test 'returns true' do
      @onboarding.update!(recaptcha_started_at: Time.now.utc)
      assert_equal true, @onboarding.recaptcha_started?
    end
  end

  describe '#recaptcha_passed?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    test 'returns false' do
      assert_equal false, @onboarding.recaptcha_passed?
    end

    test 'returns true' do
      @onboarding.update!(recaptcha_passed_at: Time.now.utc)
      assert_equal true, @onboarding.recaptcha_passed?
    end
  end

  describe '#recaptcha_incomplete?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    test 'returns true' do
      assert_equal true, @onboarding.recaptcha_incomplete?
    end

    test 'returns false' do
      @onboarding.update!(recaptcha_passed_at: Time.now.utc)
      assert_equal false, @onboarding.recaptcha_incomplete?
    end
  end

  describe '#recaptcha_too_long?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    test 'missing time in seconds' do
      assert @onboarding.respond_to?(:recaptcha_time_in_seconds)
      @onboarding.expects(:recaptcha_time_in_seconds).returns(nil)

      assert_nil @onboarding.recaptcha_too_long?
    end

    test 'calculation' do
      now = Time.now.utc

      @onboarding.update!(recaptcha_started_at: now, recaptcha_passed_at: now + 61.seconds)
      assert @onboarding.recaptcha_too_long?

      @onboarding.update!(recaptcha_started_at: now, recaptcha_passed_at: now + 60.seconds)
      assert @onboarding.recaptcha_too_long?

      @onboarding.update!(recaptcha_started_at: now, recaptcha_passed_at: now + 59.seconds)
      assert_not @onboarding.recaptcha_too_long?
    end
  end

  describe '#record_second_attempt' do
    setup do
      @onboarding = onboardings(:standard)
    end

    test 'updates attempted_again_at' do
      assert_nil @onboarding.attempted_again_at
      @onboarding.record_second_attempt

      assert_not_nil @onboarding.record_second_attempt
    end
  end

  describe '#use_override_email?' do
    describe 'follow up wording' do
      setup do
        vendor_batch = vendor_batches(:standard)
        onramp = onramps(:vendor)
        onramp.update!(vendor_batch: vendor_batch)
        @onboarding = onboardings(:standard)
        @onboarding.update!(onramp: onramp)
        Vendor.any_instance.expects(:use_override_email?).returns(true).once
      end

      it 'returns true' do
        assert @onboarding.use_override_email?
      end
    end

    describe 'no follow up wording' do
      setup do
        @onboarding = onboardings(:standard)
        @onboarding.update!(onramp: onramps(:vendor))
        Vendor.any_instance.expects(:use_override_email?).returns(false).once
      end

      it 'returns false' do
        assert_not @onboarding.use_override_email?
      end
    end
  end

  describe '#follow_up_wording' do
    setup do
      vendor = vendors(:batch)
      vendor.update!(follow_up_wording: 'follow up wording placeholder')
      vendor_batch = VendorBatch.create(vendor: vendor, survey: surveys(:standard), incentive_cents: 300, quoted_completes: 300, requested_completes: 300)
      onramp = onramps(:vendor)
      onramp.update!(vendor_batch: vendor_batch)
      @onboarding = onboardings(:standard)
      @onboarding.update!(onramp: onramp)
    end

    it 'returns the vendor follow up wording' do
      assert_equal @onboarding.follow_up_wording, @onboarding.vendor.follow_up_wording
    end
  end

  describe '#gate_survey_attempted?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns false' do
      assert_equal false, @onboarding.gate_survey_attempted?
    end
  end

  describe '#length_of_interview' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.update!(survey_finished_at: Time.now.utc)
      @onboarding.update!(survey_started_at: 60.minutes.ago(@onboarding.survey_finished_at))
    end

    it 'returns' do
      assert_equal 60, @onboarding.length_of_interview_in_minutes
    end
  end

  describe '#length_of_interview_in_minutes' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns nil' do
      assert_nil @onboarding.length_of_interview_in_minutes
    end

    it 'returns 3' do
      @onboarding.stubs(:length_of_interview).returns(180)
      assert_equal 3, @onboarding.length_of_interview_in_minutes
    end
  end

  describe '#record_response_token_usage' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns nil' do
      assert_nil @onboarding.response_token_used_at
    end

    it 'returns not nil' do
      @onboarding.record_response_token_usage
      assert_not_nil @onboarding.response_token_used_at
    end
  end

  describe '#already_loaded_response_page?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns false' do
      assert_equal false, @onboarding.already_loaded_response_page?
    end

    it 'returns true' do
      @onboarding.update!(response_token_used_at: Time.now.utc)
      assert_equal true, @onboarding.already_loaded_response_page?
    end
  end

  describe '#mark_webhook_sent' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns false' do
      assert_equal false, @onboarding.webhook_notification_sent_at.present?
    end

    it 'returns true' do
      @onboarding.mark_webhook_sent
      assert_equal true, @onboarding.webhook_notification_sent_at.present?
    end
  end

  describe '#webhook_notification_sent?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns false' do
      assert_equal false, @onboarding.webhook_notification_sent?
    end

    it 'returns true' do
      @onboarding.update!(webhook_notification_sent_at: Time.now.utc)
      assert_equal true, @onboarding.webhook_notification_sent?
    end
  end

  describe '#find_email_address' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.update!(email: 'onboardingemail@op4g.com')
    end

    it 'returns onboarding email address' do
      assert_equal 'onboardingemail@op4g.com', @onboarding.find_email_address
    end

    it 'returns panelist email address' do
      @onboarding = onboardings(:complete)
      assert_equal 'panelist@op4g.com', @onboarding.find_email_address
    end
  end

  describe '#set_security_status' do
    setup do
      @onboarding = onboardings(:complete)
      @onboarding.panelist.update!(verified_flag: true)
    end

    it 'sets security_status to unsecured' do
      @onboarding.set_security_status
      assert_equal 'verified', @onboarding.security_status
    end
  end

  describe '#gate_survey_needed_by_not_attempted?' do
    setup do
      @onboarding = onboardings(:complete)
    end

    it 'returns false' do
      assert_equal false, @onboarding.gate_survey_needed_but_not_attempted?
    end

    it 'returns true' do
      onramp = @onboarding.onramp
      onramp.update!(check_gate_survey: true)
      assert_equal true, @onboarding.gate_survey_needed_but_not_attempted?
    end
  end

  describe '#finished?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'returns false' do
      assert_equal false, @onboarding.finished?
    end

    it 'returns true' do
      @onboarding.update!(survey_finished_at: Time.now.utc)
      assert_equal true, @onboarding.finished?
    end
  end

  describe '#create panelist earning' do
    setup do
      @invitation = project_invitations(:standard)
      @onboarding = onboardings(:complete)
      @onboarding.project_invitation = @invitation
      @onboarding.onramp = onramps(:panel)
      @onboarding.save
    end

    it 'adds earnings records successfully' do
      Earning.delete_all

      assert_difference -> { Earning.count } do
        @onboarding.create_panelist_earning
      end
    end

    it 'does not add earnings records if recontact and recontact_invitation is nil' do
      Earning.delete_all

      @onramp = @onboarding.onramp
      @onramp.update!(category: :recontact)

      assert_no_difference -> { Earning.count } do
        @onboarding.create_panelist_earning
      end
    end

    it 'adds earnings records - recontact' do
      Earning.delete_all

      @onramp = @onboarding.onramp
      @onramp.update!(category: :recontact)
      @onboarding.recontact_invitation = recontact_invitations(:standard)

      assert_difference -> { Earning.count } do
        @onboarding.create_panelist_earning
      end
    end

    it 'matches the sample batch amount' do
      Earning.delete_all

      @onboarding.create_panelist_earning

      assert_equal @invitation.batch.incentive.to_f, @onboarding.earning.total_amount
    end

    it 'does not add earnings record if the onboarding has no panelist' do
      Earning.delete_all
      previous_count = Earning.count
      @onboarding.panelist = nil
      @onboarding.save!
      @onboarding.create_panelist_earning

      assert_equal previous_count, Earning.count
    end

    it 'does not add earnings record if the onboarding already has an earning' do
      previous_count = Earning.count
      onboarding = onboardings(:standard)
      onboarding.create_panelist_earning

      assert_equal previous_count, Earning.count
    end
  end

  describe '#source' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'should return the api_vendor of the onboarding' do
      @onboarding.update!(onramp: onramps(:api))
      assert @onboarding.source.is_a?(Vendor)
    end

    it 'should return the batch_vendor of the onboarding' do
      @onboarding.update!(onramp: onramps(:vendor))
      assert @onboarding.source.is_a?(Vendor)
    end

    it 'should return the panel of the onboarding' do
      @onboarding.update!(panel: panels(:standard))
      assert @onboarding.source.is_a?(Panel)
    end

    # rubocop:disable Rails::SkipsModelValidations
    it 'testing' do
      @onboarding.onramp.update_columns(category: 'testing')
      assert @onboarding.source.is_a?(Struct)
    end
    # rubocop:enable Rails::SkipsModelValidations

    it 'recontact' do
      @onboarding.onramp.update!(category: 'recontact')
      assert @onboarding.source.is_a?(Struct)
    end

    # rubocop:disable Rails::SkipsModelValidations
    it 'should return the batch_vendor of the onboarding' do
      @onboarding.onramp.update_columns(category: 'n/a')
      assert @onboarding.source.is_a?(Struct)
      assert_equal @onboarding.source.name, 'UNKNOWN DATA'
    end
  end
  # rubocop:enable Rails::SkipsModelValidations

  describe '#source_name' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'should return recontact' do
      @onboarding.onramp.update(category: 'recontact')
      assert_equal @onboarding.source_name, 'Recontact'
    end

    it 'should return unknown data' do
      @onboarding.onramp.update(category: nil)
      assert_equal @onboarding.source_name, 'UNKNOWN DATA'
    end
  end

  describe '#record_return_key' do
    setup do
      @onboarding = onboardings(:standard)
      @return_key = return_keys(:one)
    end

    it 'should not create return_key_onboarding / missing return_key param' do
      assert_no_difference -> { @onboarding.return_key_onboardings.count } do
        @onboarding.record_return_key('')
      end
    end

    it 'should not create return_key_onboarding / invalid return_key param (return_key does not exist)' do
      assert_no_difference -> { @onboarding.return_key_onboardings.count } do
        @onboarding.record_return_key('InvalidReturnKey')
      end
    end

    it 'should create return_key_onboarding / valid return_key token passed' do
      assert_difference -> { @onboarding.return_key_onboardings.count } do
        @onboarding.record_return_key(@return_key.token)
      end
    end

    it 'should create return_key_onboarding / repeat return_key token passed' do
      assert_difference -> { @onboarding.return_key_onboardings.count }, 2 do
        @onboarding.record_return_key(@return_key.token)
        @onboarding.record_return_key(@return_key.token)
      end
    end

    it 'should create return_key_onboarding / repeat return_key token passed with a different onboarding' do
      @second_onboarding = onboardings(:complete)
      assert_difference -> { ReturnKeyOnboarding.count }, 2 do
        @onboarding.record_return_key(@return_key.token)
        @second_onboarding.record_return_key(@return_key.token)
      end
    end

    it 'should create return_key_onboarding / valid return_key token passed, but belongs to a different survey' do
      @second_return_key = return_keys(:three)
      assert_difference -> { ReturnKeyOnboarding.count } do
        @onboarding.record_return_key(@second_return_key.token)
      end
    end

    it 'should set return key used! / valid return_key token passed' do
      @onboarding.record_return_key(@return_key.token)
      @key = ReturnKey.find(@onboarding.return_key_onboardings.last.return_key_id)

      assert_not_nil @key.used_at
    end
  end

  describe '#panelist_verified?' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding_complete = onboardings(:complete)
    end

    test 'panelist missing' do
      assert_not @onboarding.panelist_verified?
    end

    test 'panelist verified' do
      @onboarding_complete.panelist.verified_flag = true

      assert @onboarding_complete.panelist_verified?
    end

    test 'panelist not verified' do
      @onboarding_complete.panelist.verified_flag = false

      assert_not @onboarding_complete.panelist_verified?
    end
  end

  describe '#run_cleanid_presurvey?' do
    setup do
      @onboarding_complete = onboardings(:complete)
    end

    test 'panelist verified' do
      @onboarding_complete.panelist.verified_flag = true

      assert_not @onboarding_complete.run_cleanid_presurvey?
    end

    test 'requires security checks: false' do
      @onboarding_complete.panelist.verified_flag = false
      @onboarding_complete.bypassed_security_at = DateTime.now

      assert_not @onboarding_complete.run_cleanid_presurvey?
    end

    describe 'requires security checks: true' do
      setup do
        @onboarding_complete.panelist.verified_flag = false
        @onboarding_complete.bypassed_security_at = nil
      end

      test 'onramp: check CleanID on' do
        @onboarding_complete.onramp.check_clean_id = true

        assert @onboarding_complete.run_cleanid_presurvey?
      end

      test 'onramp: check CleanID off' do
        @onboarding_complete.onramp.check_clean_id = false

        assert_not @onboarding_complete.run_cleanid_presurvey?
      end
    end
  end

  describe '#run_recaptcha_presurvey?' do
    setup do
      @onboarding_complete = onboardings(:complete)
    end

    test 'panelist verified' do
      @onboarding_complete.panelist.verified_flag = true

      assert_not @onboarding_complete.run_recaptcha_presurvey?
    end

    test 'requires security checks: false' do
      @onboarding_complete.panelist.verified_flag = false
      @onboarding_complete.bypassed_security_at = DateTime.now

      assert_not @onboarding_complete.run_recaptcha_presurvey?
    end

    describe 'requires security checks: true' do
      setup do
        @onboarding_complete.panelist.verified_flag = false
        @onboarding_complete.bypassed_security_at = nil
      end

      test 'onramp: check reCaptcha on' do
        @onboarding_complete.onramp.check_recaptcha = true

        assert @onboarding_complete.run_recaptcha_presurvey?
      end

      test 'onramp: check reCaptcha off' do
        @onboarding_complete.onramp.check_recaptcha = false

        assert_not @onboarding_complete.run_recaptcha_presurvey?
      end
    end
  end

  describe '#run_prescreener?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    test 'no prescreener questions' do
      @onboarding.prescreener_questions.delete_all

      assert_not @onboarding.run_prescreener?
    end

    describe 'with prescreener questions' do
      test 'onramp: check prescreener turned on' do
        @onboarding.onramp.check_prescreener = true

        assert @onboarding.run_prescreener?
      end

      test 'onramp: check prescreener turned off' do
        @onboarding.onramp.check_prescreener = false

        assert_not @onboarding.run_prescreener?
      end
    end
  end

  describe '#set_panelist_score' do
    setup do
      @panelist = panelists(:standard)
      @onboarding = onboardings(:complete)
      @panelist.onboardings << @onboarding
      @panelist.update!(score: 0)
    end

    test 'enqueues panelist score job' do
      @onboarding.update!(survey_finished_at: 1.week.ago)

      assert_enqueued_with(job: CalculatePanelistScoreJob) do
        @onboarding.update!(client_status: 'accepted')
      end
    end
  end

  describe '#clean_id_data_valid?' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'should return true if clean_id_data is valid' do
      assert_equal true, @onboarding.clean_id_data_valid?
    end

    it 'should return false if clean_id_data is blank' do
      @onboarding.stubs(:clean_id_data).returns(nil)

      assert @onboarding.clean_id_data.blank?
      assert_equal false, @onboarding.clean_id_data_valid?
    end

    it 'should return false if clean_id_data is a string' do
      @onboarding.stubs(:clean_id_data).returns('This is a string')

      assert @onboarding.clean_id_data.is_a?(String)
      assert_equal false, @onboarding.clean_id_data_valid?
    end

    it 'should return false if clean_id_data is an error' do
      @onboarding.stubs(:clean_id_data).returns({ 'error' => { message: 'CORS Timeout.' } })

      assert @onboarding.clean_id_data.key?('error')
      assert_equal false, @onboarding.clean_id_data_valid?
    end
  end

  describe '#clean_id_score' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'should return the clean_id_score' do
      assert_equal 0, @onboarding.clean_id_score
    end

    it 'should return "n/a" if score is nil' do
      @onboarding.stubs(:clean_id_data).returns({ 'TransactionId' => 'eb815afc-c4eb-47e9-89a8-8981b32f7ca4', 'Score' => nil, 'ORScore' => 0.45,
                                                  'Duplicate' => false, 'IsMobile' => false })

      assert_equal 'n/a', @onboarding.clean_id_score
    end
  end

  describe '#self.disqo_completes_revenue_for_month' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.onramp.update!(category: 'disqo')
      @date = Time.now.utc
      @onboarding.update!(created_at: @date, survey_finished_at: @date)
    end

    it 'calculates revenue' do
      revenue = Onboarding.disqo_completes_revenue_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert_equal 2.0, revenue.to_f
    end
  end

  describe '#self.disqo_completes_payout_for_month' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.onramp.update!(category: 'disqo')
      @date = Time.now.utc
      @onboarding.update!(created_at: @date, survey_finished_at: @date)
    end

    it 'calculates payout if disqo quota is nil' do
      payout = Onboarding.disqo_completes_payout_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert_nil @onboarding.disqo_quota
      assert_equal 1.0, payout.to_f
    end

    it 'calculates payout if disqo quota is present' do
      disqo_quota = disqo_quotas(:second)
      disqo_quota.onramp = onramps(:disqo)
      @onboarding.disqo_quota = disqo_quota
      payout = Onboarding.disqo_completes_payout_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert @onboarding.disqo_quota.present?
      assert_equal 2.0, payout.to_f
    end
  end

  describe '#self.disqo_completes_profit_for_month' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.onramp.update!(category: 'disqo')
      @date = Time.now.utc
      @onboarding.update!(created_at: @date, survey_finished_at: @date)
    end

    it 'calculates profit if disqo quota is nil' do
      profit = Onboarding.disqo_completes_profit_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert_nil @onboarding.disqo_quota
      assert_equal 1.0, profit.to_f
    end

    it 'calculates profit if disqo quota is present' do
      disqo_quota = disqo_quotas(:standard)
      disqo_quota.onramp = onramps(:disqo)
      @onboarding.disqo_quota = disqo_quota
      profit = Onboarding.disqo_completes_profit_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert @onboarding.disqo_quota.present?
      assert_equal 1.0, profit.to_f
    end
  end

  describe '#self.cint_completes_revenue_for_month' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.onramp.update!(category: 'cint')
      @date = Time.now.utc
      @onboarding.update!(created_at: @date, survey_finished_at: @date)
    end

    it 'calculates revenue' do
      revenue = Onboarding.cint_completes_revenue_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert_equal 2.0, revenue.to_f
    end
  end

  describe '#self.cint_completes_payout_for_month' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.onramp.update!(category: 'cint')
      @date = Time.now.utc
      @onboarding.update!(created_at: @date, survey_finished_at: @date)
    end

    it 'calculates payout if cint survey is nil' do
      payout = Onboarding.cint_completes_payout_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert_nil @onboarding.cint_survey
      assert_equal 1.0, payout.to_f
    end

    it 'calculates payout if cint survey is present' do
      stub_request(:patch, 'https://fuse.cint.com/ordering/surveys/227').to_return(status: 200)
      cint_survey = cint_surveys(:standard)
      cint_survey.onramp = onramps(:cint)
      @onboarding.cint_survey = cint_survey
      @onboarding.cint_survey.update!(cpi_cents: 200)
      payout = Onboarding.cint_completes_payout_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert @onboarding.cint_survey.present?
      assert_equal 2.0, payout.to_f
    end
  end

  describe '#self.cint_completes_profit_for_month' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.onramp.update!(category: 'cint')
      @date = Time.now.utc
      @onboarding.update!(created_at: @date, survey_finished_at: @date)
    end

    it 'calculates profit if cint survey is nil' do
      profit = Onboarding.cint_completes_profit_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert_nil @onboarding.cint_survey
      assert_equal 1.0, profit.to_f
    end

    it 'calculates profit if cint survey is present' do
      cint_survey = cint_surveys(:standard)
      cint_survey.onramp = onramps(:cint)
      @onboarding.cint_survey = cint_survey
      profit = Onboarding.cint_completes_profit_for_month(month: Date::MONTHNAMES[@date.month], year: @date.year)

      assert @onboarding.cint_survey.present?
      assert_equal 1.0, profit.to_f
    end
  end

  describe '#project_closeout_status' do
    setup do
      @onboarding = onboardings(:complete)
    end

    it 'should return remaining' do
      assert_equal @onboarding.project_closeout_status, 'remaining'
    end

    it 'should return accepted' do
      @onboarding.update!(client_status: 'accepted')
      assert_equal @onboarding.project_closeout_status, 'accepted'
    end
  end

  describe '#check_if_requested_completes_reached' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.onramp = onramps(:vendor)
      @date = Time.now.utc
      @onboarding.update!(created_at: @date, survey_finished_at: @date)
    end

    it 'disables onramp' do
      assert_equal @onboarding.onramp.disabled?, false

      @onboarding.onramp.vendor_batch.update!(requested_completes: 0)
      @onboarding.survey_response_url = survey_response_urls(:complete)
      @onboarding.update!(created_at: @date, survey_finished_at: @date)

      assert_equal @onboarding.onramp.disabled?, true
    end
  end
end
