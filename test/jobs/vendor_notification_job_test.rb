# frozen_string_literal: true

require 'test_helper'

# TODO: move some of these tests into the Onboarding model test. Job should
#   just be testing that the onboarding method gets called.
# TODO: Rename this model to something more general. Returning webhooks for vendor, API, and router traffic.
class VendorNotificationJobTest < ActiveJob::TestCase
  setup do
    @onboarding = onboardings(:standard)
  end

  describe 'vendor traffic: complete response' do
    setup do
      @onboarding.update!(onramp: onramps(:vendor))
      @onboarding.record_onboarding_completion
      @onboarding.record_survey_response(@onboarding.project.complete_response)
      @vendor = @onboarding.vendor
      @vendor.update!(
        send_complete_webhook: true,
        complete_webhook_url: 'http://vendor.com/complete-webhook?id='
      )
    end

    it 'job is enqueued properly' do
      assert_no_enqueued_jobs

      assert_enqueued_with(job: VendorNotificationJob) do
        VendorNotificationJob.perform_later(@onboarding)
      end

      assert_enqueued_jobs 1
    end

    it 'webhook is only called once if job runs multiple times' do
      stub_request(:any, /vendor.com/) # Returns success.

      VendorNotificationJob.perform_now(@onboarding)
      VendorNotificationJob.perform_now(@onboarding)

      assert_requested(:post, @vendor.complete_webhook + @onboarding.uid, times: 1)
    end

    it 'job is re-enqueued if webhook is missing' do
      @vendor.update!(complete_webhook_url: nil)

      assert_no_enqueued_jobs

      VendorNotificationJob.perform_now(@onboarding)

      assert_enqueued_jobs 1
    end

    it 'job is re-enqueued is called when API fails' do
      stub_request(:any, /vendor.com/).to_return(status: 500)

      assert_no_enqueued_jobs

      VendorNotificationJob.perform_now(@onboarding)

      assert_requested(:post, @vendor.complete_webhook + @onboarding.uid, times: 1)
      assert_enqueued_jobs 1
    end
  end

  describe 'vendor traffic: term response' do
    setup do
      @onboarding.update!(onramp: onramps(:vendor))
      @onboarding.record_onboarding_completion
      @onboarding.record_survey_response(@onboarding.project.terminate_response)
      @vendor = @onboarding.vendor
      @vendor.update!(
        send_secondary_webhook: true,
        secondary_webhook_url: 'http://vendor.com/secondary-webhook?id='
      )
    end

    it 'job is enqueued properly' do
      assert_no_enqueued_jobs

      assert_enqueued_with(job: VendorNotificationJob) do
        VendorNotificationJob.perform_later(@onboarding)
      end

      assert_enqueued_jobs 1
    end

    it 'webhook is only called once if job runs multiple times' do
      stub_request(:any, /vendor.com/) # Returns success.

      VendorNotificationJob.perform_now(@onboarding)
      VendorNotificationJob.perform_now(@onboarding)

      assert_requested(:post, @vendor.secondary_webhook + @onboarding.uid, times: 1)
    end

    it 'job is re-enqueued if webhook is missing' do
      @vendor.update!(secondary_webhook_url: nil)

      assert_no_enqueued_jobs

      VendorNotificationJob.perform_now(@onboarding)

      assert_enqueued_jobs 1
    end

    it 'job is re-enqueued is called when API fails' do
      stub_request(:any, /vendor.com/).to_return(status: 500)

      assert_no_enqueued_jobs

      VendorNotificationJob.perform_now(@onboarding)

      assert_requested(:post, @vendor.secondary_webhook + @onboarding.uid, times: 1)
      assert_enqueued_jobs 1
    end
  end
end
