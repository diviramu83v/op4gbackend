# frozen_string_literal: true

require 'test_helper'

class Employee::DecodingsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_admin
  end

  describe '#new' do
    it 'should load the page' do
      get new_decoding_url

      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @decoding = decodings(:standard)
    end

    it 'should load the page' do
      get decoding_url(@decoding)

      assert_redirected_to decoding_matches_url(@decoding)
    end

    test 'load the page with decoding errors' do
      Decoding.any_instance.expects(:errors?).returns(true)

      get decoding_url(@decoding)

      assert_redirected_to decoding_errors_url(@decoding)
    end

    test 'load the page with panel traffic and multiple panels' do
      Decoding.any_instance.expects(:panel_traffic?).returns(true)
      Decoding.any_instance.expects(:multiple_panels?).returns(true)

      get decoding_url(@decoding)

      assert_redirected_to decoding_combined_url(@decoding)
    end

    test 'load the page with only one vendor' do
      @onboarding = @decoding.decoded_uids.last.onboarding
      @onboarding.onramp = onramps(:vendor)
      @onboarding.save
      @decoding.reload

      get decoding_url(@decoding)

      assert_redirected_to decoding_vendor_url(@decoding, @decoding.first_vendor)
    end
  end

  describe '#create' do
    it 'should create a decoding' do
      @params = { decoding: { encoded_uids: 'asdf' } }
      assert_difference -> { Decoding.count } do
        post decodings_url, params: @params
      end
    end

    it 'should fail to create a decoding' do
      @params = { decoding: { encoded_uids: nil } }
      assert_no_difference -> { Decoding.count } do
        post decodings_url, params: @params
      end
    end

    it 'should have the same order from different runs' do
      @params = { decoding: { encoded_uids: "xyz\nabc\nh45\n2y9\ndef\n8j3\nsz9" } }

      post decodings_url, params: @params
      Decoding.last.decode_uids
      decoded1 = []
      DecodedUid.last(7).each do |record|
        decoded1 << record.uid
      end

      post decodings_url, params: @params
      Decoding.last.decode_uids
      decoded2 = []
      DecodedUid.last(7).each do |record|
        decoded2 << record.uid
      end

      assert_equal decoded1, decoded2
    end
  end
end
