# frozen_string_literal: true

require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  describe 'route not found requests' do
    setup do
      @ip = ip_addresses(:standard)
      ActionDispatch::Request.any_instance.stubs(:remote_ip).returns(@ip.address)
      load_and_sign_in_operations_employee
    end

    describe 'random bad URL' do
      setup do
        SpamDetector.stubs(:looks_fraudulent?).returns(false).once
      end

      it 'returns not found' do
        get not_found_url
        assert_response :not_found
      end
    end

    describe 'bad json URL' do
      setup do
        SpamDetector.stubs(:looks_fraudulent?).returns(false).once
      end

      it 'returns not found' do
        get not_found_url(format: :json)
        assert_response :not_found
      end
    end

    describe 'known spam pattern' do
      setup do
        SpamDetector.stubs(:looks_fraudulent?).returns(true).once
      end

      it 'is blocked' do
        IpAddress.expects(:auto_block).once
        get not_found_url
        assert_redirected_to bad_request_url
      end
    end

    describe 'request in text/plain format' do
      it 'returns not found' do
        get bad_request_url(format: :text)
        assert_response :bad_request
      end
    end

    describe '#unprocessable_entity' do
      test 'renders status' do
        get unprocessable_entity_url
        assert_response :unprocessable_entity
      end
    end

    describe '#internal_server_error' do
      test 'renders status' do
        get internal_server_error_url
        assert_response :internal_server_error
      end
    end
  end
end
