# frozen_string_literal: true

require 'test_helper'

class UrlHasherTest < ActiveSupport::TestCase
  describe 'validation' do
    test 'requires url to be non-nil' do
      assert_raises RuntimeError do
        UrlHasher.new(url: nil, vendor: vendors(:api))
      end
    end

    test 'requires vendor to be non-nil' do
      assert_raises RuntimeError do
        UrlHasher.new(url: 'https://test.com/?status=1', vendor: nil)
      end
    end
  end

  describe '#url_hashed_if_needed' do
    setup do
      @vendor = vendors(:api)

      @hasher = UrlHasher.new(
        url: 'https://samppoint.com/end/?status=1&sjid=12345',
        vendor: @vendor
      )
    end

    describe 'vendor.hash_key missing' do
      setup do
        Vendor.any_instance.expects(:hash_key).returns(nil).once
      end

      test 'returns url unchanged' do
        assert_equal 'https://samppoint.com/end/?status=1&sjid=12345', @hasher.url_hashed_if_needed
      end
    end

    describe 'vendor includes hash_param in hash calculation' do
      setup do
        @vendor.update!(
          hash_key: '1234abc13as43',
          hashing_param: 'checksum',
          include_hashing_param_in_hash_data: true
        )
      end

      test 'calculates and adds the expected hash parameter' do
        output = 'https://samppoint.com/end/?status=1&sjid=12345&checksum=20f872d810e8378bee31b89307bfec04eea6ab5a'

        assert_equal output, @hasher.url_hashed_if_needed
      end
    end

    describe 'vendor does not include hash_param in hash calculation' do
      setup do
        @vendor.update!(
          hash_key: '1243rdasdf12wr3eq312eweqwoepo23u291',
          hashing_param: 'hmac_token',
          include_hashing_param_in_hash_data: false
        )

        @hasher = UrlHasher.new(
          url: 'https://papa.paasresearch.com/completed-entry/?response=1008&pid=1_45c9ee85-e2a4-439f-9ec6-0c996c7257f9',
          vendor: @vendor
        )
      end

      test 'calculates and adds the expected hash parameter' do
        output = 'https://papa.paasresearch.com/completed-entry/?response=1008&pid=1_45c9ee85-e2a4-439f-9ec6-0c996c7257f9&hmac_token=9b664b0a4389cbc1010956c46ab67ceb68fb25cc'

        assert_equal output, @hasher.url_hashed_if_needed
      end
    end
  end
end
