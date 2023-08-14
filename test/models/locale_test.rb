# frozen_string_literal: true

require 'test_helper'

class LocaleTest < ActiveSupport::TestCase
  describe 'class methods' do
    describe '.default' do
      it 'returns en' do
        assert_equal 'en', Locale.default
      end
    end

    describe '.recapcha_session' do
      it 'returns en as the default' do
        assert_equal 'en', Locale.recaptcha_session(nil)
      end

      it 'changes uk to en' do
        assert_equal 'en', Locale.recaptcha_session('uk')
      end

      it 'passes anything else through' do
        assert_equal 'en', Locale.recaptcha_session('en')
        assert_equal 'fr', Locale.recaptcha_session('fr')
        assert_equal 'de', Locale.recaptcha_session('de')
      end
    end
  end
end
