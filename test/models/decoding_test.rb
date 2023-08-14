# frozen_string_literal: true

require 'test_helper'

class DecodingTest < ActiveSupport::TestCase
  setup do
    @decoding = decodings(:standard)
  end

  describe 'fixture' do
    it 'is valid' do
      @decoding.valid?
      assert_empty @decoding.errors
    end

    test 'connection to decoded_uid records' do
      assert_includes @decoding.decoded_uids, decoded_uids(:standard)
      assert_includes @decoding.decoded_uids, decoded_uids(:second)
    end
  end

  describe 'methods' do
    describe 'decode_uids' do
      setup do
        @decoding.update!(decoded_at: nil)
        DecodedUid.destroy_all
        assert_equal 0, DecodedUid.count
      end

      test 'creates decoded_uid records' do
        assert_difference 'DecodedUid.count', 2 do
          @decoding.decode_uids
        end
      end

      describe 'processed first in first out' do
        test 'entered a-z' do
          @decoding.update!(encoded_uids: "abc\nxyz")
          @decoding.decode_uids

          decoded_uids = @decoding.decoded_uids
          assert_equal 'abc', decoded_uids[0].uid
          assert_equal 'xyz', decoded_uids[1].uid
          assert_equal 1, decoded_uids[0].entry_number
          assert_equal 2, decoded_uids[1].entry_number
        end

        test 'entered z-a' do
          @decoding.update!(encoded_uids: "xyz\nabc")
          @decoding.decode_uids

          decoded_uids = @decoding.decoded_uids
          assert_equal 'xyz', decoded_uids[0].uid
          assert_equal 'abc', decoded_uids[1].uid
          assert_equal 1, decoded_uids[0].entry_number
          assert_equal 2, decoded_uids[1].entry_number
        end
      end
    end
  end

  describe 'SharedDecoders concern' do
    describe '#update_onboardings_status' do
      setup do
        @decoding = decodings(:standard)
      end

      it 'should update the onboardings to the given status' do
        @decoding.update_onboardings_status('accepted')

        assert @decoding.onboardings.all?(&:accepted?)
      end
    end

    describe '#matched_uids_for_survey' do
      setup do
        @decoding = decodings(:standard)
        @survey = surveys(:standard)
        @decoding.matched_uids.first(2).each { |uid| uid.onramp.update!(survey_id: @survey.id) }
      end

      it 'returns the decoded uids that belong to a given survey' do
        assert_equal @decoding.matched_uids_for_survey(@survey).count, 2
      end
    end

    describe '#unique_sources_for_survey' do
      setup do
        @decoding = decodings(:standard)
        @survey = surveys(:standard)
        DecodedUid.any_instance.stubs(:source).returns(panels(:standard))
      end

      it 'returns the unique sources for the matched uids for a given survey' do
        assert_equal @decoding.unique_sources_for_survey(@survey).count, 1
      end
    end
  end
end
