# frozen_string_literal: true

require 'test_helper'

class FeatureManagerTest < ActiveSupport::TestCase
  subject { FeatureManager }

  describe '.ip_auto_blocking?' do
    describe 'ip blocking ENV var on' do
      before do
        ENV.stubs(:fetch).returns('on')
      end

      it 'returns true' do
        assert subject.ip_auto_blocking?
      end
    end

    describe 'ip blocking ENV var false' do
      before do
        ENV.stubs(:fetch).returns('off')
      end

      it 'returns false' do
        assert_not subject.ip_auto_blocking?
      end
    end

    describe 'ip blocking ENV var missing' do
      before do
        ENV.stubs(:fetch).returns(nil)
      end

      it 'returns false' do
        assert_not subject.ip_auto_blocking?
      end
    end
  end

  describe '.send_real_mimi_emails?' do
    describe 'mimi emails ENV var on' do
      before do
        ENV.stubs(:fetch).returns('on')
      end

      it 'returns true' do
        assert subject.send_real_mimi_emails?
      end
    end

    describe 'mimi emails ENV var off' do
      before do
        ENV.stubs(:fetch).returns('off')
      end

      it 'returns false' do
        assert_not subject.send_real_mimi_emails?
      end
    end

    describe 'mimi emails ENV var missing' do
      before do
        ENV.stubs(:fetch).returns(nil)
      end

      it 'returns false' do
        assert_not subject.send_real_mimi_emails?
      end
    end
  end

  describe '.panelist_facebook_auth' do
    describe 'panelist facebook auth ENV var on' do
      before do
        ENV.stubs(:fetch).returns('on')
      end

      it 'returns true' do
        assert subject.panelist_facebook_auth?
      end
    end

    describe 'panelist facebook auth ENV var off' do
      before do
        ENV.stubs(:fetch).returns('off')
      end

      it 'returns false' do
        assert_not subject.panelist_facebook_auth?
      end
    end

    describe 'panelist facebook auth ENV var missing' do
      before do
        ENV.stubs(:fetch).returns(nil)
      end

      it 'returns false' do
        assert_not subject.panelist_facebook_auth?
      end
    end
  end

  describe '.panelist_paypal_verification' do
    describe 'panelist paypal verification ENV var on' do
      before do
        ENV.stubs(:fetch).returns('on')
      end

      it 'returns true' do
        assert subject.panelist_paypal_verification?
      end
    end

    describe 'panelist paypal verification ENV var off' do
      before do
        ENV.stubs(:fetch).returns('off')
      end

      it 'returns false' do
        assert_not subject.panelist_paypal_verification?
      end
    end

    describe 'panelist paypal verification ENV var missing' do
      before do
        ENV.stubs(:fetch).returns(nil)
      end

      it 'returns false' do
        assert_not subject.panelist_paypal_verification?
      end
    end
  end
end
