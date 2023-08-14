# frozen_string_literal: true

require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  subject { vendors(:batch) }

  describe 'fixture' do
    describe 'batch' do
      it 'is valid' do
        vendor = vendors(:batch)
        assert vendor.valid?
        assert_empty vendor.errors
      end
    end

    describe 'api' do
      it 'is valid' do
        vendor = vendors(:api)
        assert vendor.valid?
        assert_empty vendor.errors
      end
    end
  end

  describe 'columns' do
    test 'response' do
      assert_respond_to subject, :send_complete_webhook
    end
  end

  describe 'methods' do
    it 'responds' do
      assert_respond_to subject, :disable_redirects
    end
  end

  describe '#use_override_email?' do
    describe 'follow up wording' do
      setup do
        @vendor = vendors(:batch)
        @vendor.update!(follow_up_wording: 'stuff')
      end

      it 'returns true' do
        assert @vendor.use_override_email?
      end
    end

    describe 'no follow up wording' do
      setup do
        @vendor = vendors(:batch)
        @vendor.update!(follow_up_wording: nil)
      end

      it 'returns false' do
        assert_not @vendor.use_override_email?
      end
    end
  end

  describe '#total_onboardings_past_year' do
    setup do
      @vendor = vendors(:batch)
      onramp = onramps(:vendor)
      onboarding1 = onboardings(:standard)
      onboarding2 = onboardings(:second)
      onboarding1.update(created_at: 10.months.ago)
      onboarding2.update(created_at: 2.years.ago)
      onramp.onboardings << onboarding1
      onramp.onboardings << onboarding2
    end

    it 'returns the total onboardings' do
      assert_equal 1, @vendor.total_onboardings_past_year
    end
  end

  describe '#total_blocked_onboardings_past_year' do
    setup do
      @vendor = vendors(:batch)
      onramp = onramps(:vendor)
      onboarding1 = onboardings(:standard)
      onboarding2 = onboardings(:second)
      onboarding1.update(created_at: 10.months.ago)
      onboarding2.update(created_at: 2.years.ago)
      onboarding1.blocked!
      onboarding2.blocked!
      onramp.onboardings << onboarding1
      onramp.onboardings << onboarding2
    end

    it 'returns the total blocked onboardings' do
      assert_equal 1, @vendor.total_blocked_onboardings_past_year
    end
  end

  describe '#block_rate_percentage_past_year' do
    setup do
      @vendor = vendors(:batch)
      onramp = onramps(:vendor)
      onboarding1 = onboardings(:standard)
      onboarding2 = onboardings(:second)
      onboarding1.update(created_at: 10.months.ago)
      onboarding2.update(created_at: 2.months.ago)
      onboarding2.blocked!
      onramp.onboardings << onboarding1
      onramp.onboardings << onboarding2
    end

    it 'returns the block rate percentage' do
      assert_equal 2, @vendor.total_onboardings_past_year
      assert_equal 1, @vendor.total_blocked_onboardings_past_year
      assert_equal 50.00, @vendor.block_rate_percentage_past_year
    end
  end
end
