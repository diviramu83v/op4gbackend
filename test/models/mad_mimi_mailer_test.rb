# frozen_string_literal: true

require 'test_helper'

class MadMimiMailerTest < ActiveSupport::TestCase
  setup do
    @mailer = MadMimiMailer.instance
  end

  describe 'allow_real_emails?' do
    describe 'ENV var missing' do
      setup do
        ENV.stubs(:[]).with('SEND_EMAIL_FOR_REAL').returns(nil)
      end

      it 'returns false' do
        assert_not @mailer.allow_real_emails?
      end
    end

    describe 'ENV var set to no' do
      setup do
        ENV.stubs(:[]).with('SEND_EMAIL_FOR_REAL').returns('no')
      end

      it 'returns false' do
        assert_not @mailer.allow_real_emails?
      end
    end

    describe 'ENV var set to yes' do
      setup do
        ENV.stubs(:[]).with('SEND_EMAIL_FOR_REAL').returns('yes')
      end

      it 'returns true' do
        assert @mailer.allow_real_emails?
      end
    end
  end
end
