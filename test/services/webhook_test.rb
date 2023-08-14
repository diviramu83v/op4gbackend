# frozen_string_literal: true

require 'test_helper'

class WebhookTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  describe '#notify_vendor_via_webhook' do
    setup do
      @onboarding = onboardings(:standard)
      @onboarding.record_onboarding_completion
    end

    describe 'webhook turned on' do
      setup do
        @onboarding.onramp.expects(:webhook_allowed?).returns(true).at_least_once
        Webhook.any_instance.expects(:webhook_full_url).returns('some_url').at_least_once
      end

      describe 'vendor webhook method is PUT' do
        setup do
          vendor = mock
          vendor.expects(:try).with(:webhook_method).returns('get')
          Onboarding.any_instance.stubs(:vendor).returns(vendor)
        end

        test 'sends GET to fixie' do
          Fixie.expects(:public_send).with('get', url: 'some_url').returns(true)
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end

      describe 'vendor webhook method is POST' do
        setup do
          vendor = mock
          vendor.expects(:try).with(:webhook_method).returns('post')
          Onboarding.any_instance.stubs(:vendor).returns(vendor)
        end

        test 'sends POST to fixie' do
          Fixie.expects(:public_send).with('post', url: 'some_url').returns(true)
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end

      describe 'vendor is missing' do
        setup do
          Onboarding.any_instance.stubs(:vendor).returns(nil)
        end

        test 'sends POST to fixie' do
          Fixie.expects(:public_send).with('post', url: 'some_url').returns(true)
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end
    end

    describe 'vendor onramp' do
      setup do
        @onboarding.update!(onramp: onramps(:vendor))
      end

      describe 'complete response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.complete_response)
        end

        describe 'complete webhook on' do
          setup do
            @onboarding.vendor.update!(
              send_complete_webhook: true,
              complete_webhook_url: 'https://batch.vendor.com/complete-webhook?uid='
            )
          end

          test 'posts back' do
            Fixie.expects(:post).with(url: 'https://batch.vendor.com/complete-webhook?uid=123').once
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end

        describe 'complete webhook off' do
          setup do
            @onboarding.vendor.update!(send_complete_webhook: false)
          end

          test 'does not post back' do
            Fixie.expects(:post).never
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end
      end

      describe 'term response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.terminate_response)
        end

        describe 'secondary webhook on' do
          setup do
            @onboarding.vendor.update!(
              send_secondary_webhook: true,
              secondary_webhook_url: 'https://batch.vendor.com/secondary-webhook?uid='
            )
          end

          test 'posts back' do
            Fixie.expects(:post).with(url: 'https://batch.vendor.com/secondary-webhook?uid=123').once
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end

        describe 'secondary webhook off' do
          setup do
            @onboarding.vendor.update!(send_secondary_webhook: false)
          end

          test 'does not post back' do
            Fixie.expects(:post).never
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end
      end

      describe 'full response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.quotafull_response)
        end

        describe 'secondary webhook on' do
          setup do
            @onboarding.vendor.update!(
              send_secondary_webhook: true,
              secondary_webhook_url: 'https://batch.vendor.com/secondary-webhook?uid='
            )
          end

          test 'posts back' do
            Fixie.expects(:post).with(url: 'https://batch.vendor.com/secondary-webhook?uid=123').once
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end

        describe 'secondary webhook off' do
          setup do
            @onboarding.vendor.update!(send_secondary_webhook: false)
          end

          test 'does not post back' do
            Fixie.expects(:post).never
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end
      end
    end

    describe 'API onramp' do
      setup do
        @onboarding.update!(onramp: onramps(:api))
      end

      describe 'complete response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.complete_response)
        end

        describe 'complete webhook on' do
          setup do
            @onboarding.vendor.update!(
              send_complete_webhook: true,
              complete_webhook_url: 'https://batch.vendor.com/complete-webhook?uid='
            )
          end

          test 'posts back' do
            Fixie.expects(:post).with(url: 'https://batch.vendor.com/complete-webhook?uid=123').once
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end

        describe 'complete webhook off' do
          setup do
            @onboarding.vendor.update!(send_complete_webhook: false)
          end

          test 'does not post back' do
            Fixie.expects(:post).never
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end
      end

      describe 'term response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.terminate_response)
        end

        describe 'secondary webhook on' do
          setup do
            @onboarding.vendor.update!(
              send_secondary_webhook: true,
              secondary_webhook_url: 'https://batch.vendor.com/secondary-webhook?uid='
            )
          end

          test 'posts back' do
            Fixie.expects(:post).with(url: 'https://batch.vendor.com/secondary-webhook?uid=123').once
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end

        describe 'secondary webhook off' do
          setup do
            @onboarding.vendor.update!(send_secondary_webhook: false)
          end

          test 'does not post back' do
            Fixie.expects(:post).never
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end
      end

      describe 'full response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.quotafull_response)
        end

        describe 'secondary webhook on' do
          setup do
            @onboarding.vendor.update!(
              send_secondary_webhook: true,
              secondary_webhook_url: 'https://batch.vendor.com/secondary-webhook?uid='
            )
          end

          test 'posts back' do
            Fixie.expects(:post).with(url: 'https://batch.vendor.com/secondary-webhook?uid=123').once
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end

        describe 'secondary webhook off' do
          setup do
            @onboarding.vendor.update!(send_secondary_webhook: false)
          end

          test 'does not post back' do
            Fixie.expects(:post).never
            Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
          end
        end
      end
    end

    # Webhooks can never be on/off. No vendor.
    describe 'panel onramp' do
      setup do
        @onboarding.update!(onramp: onramps(:panel))
        assert_nil @onboarding.vendor
      end

      describe 'complete response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.complete_response)
        end

        test 'does not post back' do
          Fixie.expects(:post).never
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end

      describe 'term response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.terminate_response)
        end

        test 'does not post back' do
          Fixie.expects(:post).never
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end

      describe 'full response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.quotafull_response)
        end

        test 'does not post back' do
          Fixie.expects(:post).never
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end
    end

    # Webhooks can never be on/off. No vendor.
    describe 'testing onramp' do
      setup do
        @onboarding.update!(onramp: onramps(:testing))
        assert_nil @onboarding.vendor
      end

      describe 'complete response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.complete_response)
        end

        test 'does not post back' do
          Fixie.expects(:post).never
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end

      describe 'term response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.terminate_response)
        end

        test 'does not post back' do
          Fixie.expects(:post).never
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end

      describe 'full response' do
        setup do
          @onboarding.record_survey_response(@onboarding.project.quotafull_response)
        end

        test 'does not post back' do
          Fixie.expects(:post).never
          Webhook.new(onboarding: @onboarding).notify_vendor_via_webhook
        end
      end
    end
  end

  describe '#call_vendor_webhook' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'starts the vendor notification job if the onboarding is webhook ready' do
      Onramp.any_instance.expects(:webhook_allowed?).returns(true)
      Webhook.any_instance.expects(:webhook_full_url).returns('something')

      assert_enqueued_with(job: VendorNotificationJob) do
        @onboarding.call_vendor_webhook
      end
    end

    it 'does not start the vendor notification job if the onboarding is not webhook ready' do
      Onramp.any_instance.expects(:webhook_allowed?).returns(false)

      @onboarding.call_vendor_webhook

      assert_no_enqueued_jobs
    end
  end
end
