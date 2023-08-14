# frozen_string_literal: true

require 'test_helper'

class EarningTest < ActiveSupport::TestCase
  describe 'fixture' do
    setup { @earning = earnings(:one) }

    it 'is valid' do
      @earning.valid?
      assert_empty @earning.errors
    end
  end

  describe '#original_uid' do
    setup do
      @earning = earnings(:one)
      @onboarding = onboardings(:standard)
    end

    it 'should return the onboarding uid' do
      assert_equal @earning.original_uid, @onboarding.uid
    end
  end
end
