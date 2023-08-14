# frozen_string_literal: true

require 'test_helper'
class VendorBatchTest < ActiveSupport::TestCase
  setup do
    @batch = vendor_batches(:standard)

    @batch_complete_url = 'http://vendorbatch.com/complete-test?uid='
    @batch_terminate_url = 'http://vendorbatch.com/terminate-test?uid='
    @batch_overquota_url = 'http://vendorbatch.com/overquota-test?uid='
    @batch_security_url = 'http://vendorbatch.com/security-test?uid='

    @vendor_complete_url = 'http://vendor.com/complete-test?uid='
    @vendor_terminate_url = 'http://vendor.com/terminate-test?uid='
    @vendor_overquota_url = 'http://vendor.com/overquota-test?uid='
    @vendor_security_url = 'http://vendor.com/security-test?uid='
  end

  describe 'validation' do
    it 'requires three primary urls for consistency' do
      set_all_vendor_batch_urls

      assert_raises ActiveRecord::RecordInvalid do
        @batch.update!(complete_url: nil)
      end
      assert_raises ActiveRecord::RecordInvalid do
        @batch.update!(terminate_url: nil)
      end
      assert_raises ActiveRecord::RecordInvalid do
        @batch.update!(overquota_url: nil)
      end

      # Removing security URL is okay.
      @batch.update!(security_url: nil)
      @batch.vendor.update!(security_url: nil)
      assert_nil @batch.security_url
      assert @batch.valid?
    end

    it 'requires urls to start with http or https' do
      set_all_vendor_batch_urls

      assert_raises ActiveRecord::RecordInvalid do
        @batch.update!(
          complete_url: 'htt://vendorbatch.com/complete-test?uid='
        )
      end
      assert_raises ActiveRecord::RecordInvalid do
        @batch.update!(
          terminate_url: 'htt://vendorbatch.com/terminate-test?uid='
        )
      end
      assert_raises ActiveRecord::RecordInvalid do
        @batch.update!(
          overquota_url: 'htt://vendorbatch.com/overquota-test?uid='
        )
      end
      assert_raises ActiveRecord::RecordInvalid do
        @batch.update!(
          security_url: 'htt://vendorbatch.com/security-test?uid='
        )
      end
    end

    it 'requires urls when vendor urls missing' do
      Survey.any_instance.stubs(:live?).returns(true)

      clear_all_vendor_urls

      assert_raises ActiveRecord::RecordInvalid do
        clear_all_vendor_batch_urls
      end
    end

    it 'urls work without vendor urls' do
      clear_all_vendor_urls
      set_all_vendor_batch_urls

      assert_equal @batch.complete_url, @batch_complete_url
      assert_equal @batch.terminate_url, @batch_terminate_url
      assert_equal @batch.overquota_url, @batch_overquota_url
      assert_equal @batch.security_url, @batch_security_url
    end

    it 'urls fall back to vendor urls' do
      set_all_vendor_urls
      clear_all_vendor_batch_urls

      assert_equal @batch.complete_url, @vendor_complete_url
      assert_equal @batch.terminate_url, @vendor_terminate_url
      assert_equal @batch.overquota_url, @vendor_overquota_url
      assert_equal @batch.security_url, @vendor_security_url
    end

    it 'urls override vendor urls' do
      set_all_vendor_urls
      set_all_vendor_batch_urls

      assert_equal @batch.complete_url, @batch_complete_url
      assert_equal @batch.terminate_url, @batch_terminate_url
      assert_equal @batch.overquota_url, @batch_overquota_url
      assert_equal @batch.security_url, @batch_security_url
    end
  end

  describe 'automatic onramp creation' do
    describe 'vendor security disabled' do
      setup do
        @batch = vendor_batches(:standard)
        @vendor = @batch.vendor
        @vendor.update!(security_disabled_by_default: true)
        @batch.onramp.update!(check_recaptcha: false)
      end

      it 'sets onramp checks appropriately' do
        assert_equal @batch.vendor.security_disabled_by_default, true
        assert_equal @batch.onramp.check_recaptcha, false
        assert_equal 'vendor', @batch.onramp.category
      end
    end

    describe 'vendor security enabled' do
      setup do
        @batch = vendor_batches(:standard)
        @vendor = vendors(:batch)
        @vendor.update!(security_disabled_by_default: false)
      end

      it 'sets onramp checks appropriately' do
        assert_equal @batch.vendor.security_disabled_by_default, false
        assert_equal @batch.onramp.check_recaptcha, true
      end
    end
  end

  describe '#editable?' do
    describe 'survey is a draft' do
      setup do
        @batch.survey.expects(:draft?).returns(true).once
      end

      it 'returns true' do
        assert @batch.editable?
      end
    end

    describe 'survey is live' do
      setup do
        @batch.survey.expects(:draft?).returns(false).once
        @batch.survey.expects(:live?).returns(true).once
      end

      it 'returns true' do
        assert @batch.editable?
      end
    end

    describe 'survey is on hold' do
      setup do
        @batch.survey.expects(:draft?).returns(false).once
        @batch.survey.expects(:live?).returns(false).once
        @batch.survey.expects(:on_hold?).returns(true).once
      end

      it 'returns true' do
        assert @batch.editable?
      end
    end

    describe 'survey is not draft, live, or on hold' do
      setup do
        @batch.survey.expects(:draft?).returns(false).once
        @batch.survey.expects(:live?).returns(false).once
        @batch.survey.expects(:on_hold?).returns(false).once
      end

      it 'returns false' do
        assert_not @batch.editable?
      end
    end
  end

  describe '#incentive' do
    it 'raises validation error when incentive_cents is 0' do
      assert_raises(ActiveRecord::RecordInvalid) do
        @batch.update!(incentive_cents: 0)
      end
    end

    it 'is 5.0 when incentive_cents is 500' do
      @batch.update!(incentive_cents: 500)
      assert_equal @batch.incentive.to_f, 5.0
    end

    it 'is 5.01 when incentive_cents is 501' do
      @batch.update!(incentive_cents: 501)
      assert_equal @batch.incentive.to_f, 5.01
    end
  end

  describe '#incentive=' do
    it 'correctly sets incentive_cents' do
      @batch.incentive = 5.00
      assert_equal @batch.incentive_cents, 500

      @batch.incentive = 5.01
      assert_equal @batch.incentive_cents, 501

      @batch.incentive = 0
      assert_equal @batch.incentive_cents, 0
    end
  end

  describe '#using_redirects?' do
    describe 'vendor redirects disabled' do
      setup do
        @batch.vendor.expects(:disable_redirects?).returns(true).once
      end

      it 'returns false' do
        assert_not @batch.using_redirects?
      end
    end

    describe 'vendor redirects enabled' do
      setup do
        @batch.vendor.expects(:disable_redirects?).returns(false).once
      end

      it 'returns false' do
        assert @batch.using_redirects?
      end
    end
  end

  describe '#base_redirect_url' do
    setup do
      @response = survey_response_urls(:complete)
      @response.update!(project: @batch.survey.project)
    end

    describe 'redirects disabled' do
      setup do
        @batch.expects(:using_redirects?).returns(false).once
      end

      it 'returns nil' do
        assert_nil @batch.base_redirect_url(@response)
      end
    end

    describe 'redirects enabled' do
      setup do
        @batch.expects(:using_redirects?).returns(true).once
      end

      it 'returns a url' do
        assert_equal @batch.complete_url, @batch.base_redirect_url(@response)
      end
    end
  end

  describe '#base_security_redirect_url' do
    setup do
      survey_response_url = survey_response_urls(:complete)
      survey_response_url.update(project: @batch.survey.project)
      set_all_vendor_urls
    end

    describe 'redirects disabled' do
      setup do
        @batch.expects(:using_redirects?).returns(false).once
      end

      it 'returns nil' do
        assert_nil @batch.base_security_redirect_url
      end
    end

    describe 'redirects enabled' do
      setup do
        @batch.expects(:using_redirects?).returns(true).once
      end

      it 'returns a url' do
        assert_equal @batch.security_url, @batch.base_security_redirect_url
      end
    end
  end

  private

  def clear_all_vendor_urls
    @batch.vendor.update!(
      complete_url: nil,
      terminate_url: nil,
      overquota_url: nil,
      security_url: nil
    )
  end

  def clear_all_vendor_batch_urls
    @batch.update!(
      complete_url: nil,
      terminate_url: nil,
      overquota_url: nil,
      security_url: nil
    )
  end

  def set_all_vendor_urls
    @batch.vendor.update!(
      complete_url: @vendor_complete_url,
      terminate_url: @vendor_terminate_url,
      overquota_url: @vendor_overquota_url,
      security_url: @vendor_security_url
    )
  end

  def set_all_vendor_batch_urls
    @batch.update!(
      complete_url: @batch_complete_url,
      terminate_url: @batch_terminate_url,
      overquota_url: @batch_overquota_url,
      security_url: @batch_security_url
    )
  end
end
