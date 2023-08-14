# frozen_string_literal: true

require 'test_helper'

class ReturnKeyAnalyzerTest < ActiveSupport::TestCase
  setup do
    @onboarding = onboardings(:standard)
    @survey = @onboarding.survey
    @return_key = return_keys(:one)
  end

  describe '#bad_key' do
    it 'should return false / survey does not use_return_keys' do
      @survey.expects(:uses_return_keys?).returns(false)
      @onboarding.return_key_onboardings.create!(return_key: @return_key)
      @key_analyzer = ReturnKeyAnalyzer.new(onboarding: @onboarding)

      assert_equal false, @key_analyzer.bad_key?
    end

    it 'should return true / missing return_key' do
      @survey.expects(:uses_return_keys?).returns(true)
      @onboarding.return_key_onboardings.delete_all
      @key_analyzer = ReturnKeyAnalyzer.new(onboarding: @onboarding)

      assert_equal true, @key_analyzer.bad_key?
    end

    it 'should return true / onboarding has previously used return_key' do
      @second_return_key = return_keys(:three)
      @survey.expects(:uses_return_keys?).returns(true)
      @onboarding.return_key_onboardings.create!(return_key: @return_key)
      @onboarding.return_key_onboardings.create!(return_key: @second_return_key)
      @key_analyzer = ReturnKeyAnalyzer.new(onboarding: @onboarding)

      assert_equal true, @key_analyzer.bad_key?
    end

    it 'should return true / return_key has been previously used' do
      @second_onboarding = onboardings(:complete)
      @survey.expects(:uses_return_keys?).returns(true)
      @second_onboarding.return_key_onboardings.create!(return_key: @return_key)
      @onboarding.return_key_onboardings.create!(return_key: @return_key)
      @key_analyzer = ReturnKeyAnalyzer.new(onboarding: @onboarding)

      assert_equal true, @key_analyzer.bad_key?
    end

    it 'should return true / mismatched survey' do
      @second_return_key = return_keys(:three)
      @survey.expects(:uses_return_keys?).returns(true)
      @onboarding.return_key_onboardings.create!(return_key: @second_return_key)
      @key_analyzer = ReturnKeyAnalyzer.new(onboarding: @onboarding)

      assert_equal true, @key_analyzer.bad_key?
    end

    it 'should return false / happy path' do
      @survey.expects(:uses_return_keys?).returns(true)
      @onboarding.return_key_onboardings.create!(return_key: @return_key)
      @key_analyzer = ReturnKeyAnalyzer.new(onboarding: @onboarding)

      assert_equal false, @key_analyzer.bad_key?
    end
  end
end
