# frozen_string_literal: true

require 'test_helper'

class RecaptchaTest < ActiveSupport::TestCase
  describe 'successful recaptcha' do
    setup do
      mock_request = mock('request')
      mock_request.stubs(:ip).returns('1.1.1.1')
      mock_request.stubs(:host).returns('test-host')
      @recaptcha = Recaptcha.new(mock_request, 'secret')

      response_body = { success: true, hostname: 'test-host' }.to_json

      stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify')
        .to_return(status: 200, body: response_body, headers: {})
    end

    test 'token_valid?' do
      assert @recaptcha.token_valid?('fake_token')
    end

    test 'token_invalid?' do
      assert_not @recaptcha.token_invalid?('fake_token')
    end
  end

  describe 'recaptcha errors' do
    setup do
      mock_request = mock('request')
      mock_request.stubs(:ip).returns('1.1.1.1')
      @recaptcha = Recaptcha.new(mock_request, 'secret')
    end

    describe 'JSON::ParserError' do
      setup do
        stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify')
          .to_return(status: 200, body: 'not-json', headers: {})
      end

      test 'token_valid?' do
        assert_not @recaptcha.token_valid?('fake_token')
      end

      test 'token_invalid?' do
        assert @recaptcha.token_invalid?('fake_token')
      end
    end

    describe 'Net::OpenTimeout' do
      setup do
        stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify')
          .to_raise(Net::OpenTimeout)
      end

      test 'token_valid?' do
        assert_not @recaptcha.token_valid?('fake_token')
      end

      test 'token_invalid?' do
        assert @recaptcha.token_invalid?('fake_token')
      end
    end
  end
end
