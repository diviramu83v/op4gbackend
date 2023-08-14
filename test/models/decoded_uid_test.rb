# frozen_string_literal: true

require 'test_helper'

class DecodedUidTest < ActiveSupport::TestCase
  describe 'fixture' do
    describe 'standard' do
      setup do
        @decoded_uid = decoded_uids(:standard)
      end

      it 'is valid' do
        @decoded_uid.valid?
        assert_empty @decoded_uid.errors
      end

      it 'is connected to the right traffic record' do
        @decoded_uid.onboarding = onboardings(:standard)
        @decoded_uid.uid = onboardings(:standard).uid
      end
    end

    describe 'second' do
      setup do
        @decoded_uid = decoded_uids(:second)
      end

      it 'is valid' do
        @decoded_uid.valid?
        assert_empty @decoded_uid.errors
      end

      it 'is connected to the right traffic record' do
        @decoded_uid.onboarding = onboardings(:second)
        @decoded_uid.uid = onboardings(:second).uid
      end
    end
  end

  it 'decoded uid record looks up related traffic (onboarding) record if it exists' do
    traffic = onboardings(:standard)
    decoding = decodings(:standard)

    decoded_uid = DecodedUid.create(decodable: decoding, uid: traffic.token)

    assert_equal decoded_uid.onboarding, traffic
  end

  it 'decoded UID record stores nothing if no related traffic (onboarding) record found' do
    decoding = decodings(:standard)

    decoded_uid = DecodedUid.create(decodable: decoding, uid: 'no-match')

    assert_nil decoded_uid.onboarding
  end
end
