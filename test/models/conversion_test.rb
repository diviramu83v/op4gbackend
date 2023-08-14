# frozen_string_literal: true

require 'test_helper'

class ConversionTest < ActiveSupport::TestCase
  describe 'fixture' do
    setup do
      @conversion = conversions(:one)
    end

    it 'is valid' do
      assert @conversion.valid?
    end
  end

  describe '.process_new_conversions' do
    setup do
      data = [
        {
          'tune_event_id' => '3',
          'offer_id' => '789',
          'payout' => '8.00',
          'datetime' => '2019-01-11 00:17:06'
        }
      ]

      TuneApi.any_instance.expects(:find_new_conversions_for_offer).returns(data)
    end

    test 'success' do
      assert_difference 'Conversion.count' do
        Conversion.process_new_conversions('test-offer')
      end
    end

    test 'invalid data' do
      Conversion.expects(:create!).raises(ActiveRecord::RecordInvalid)

      assert_no_difference 'Conversion.count' do
        Conversion.process_new_conversions('test-offer')
      end
    end

    test 'repeat data' do
      Conversion.expects(:create!).raises(ActiveRecord::RecordNotUnique)

      assert_no_difference 'Conversion.count' do
        Conversion.process_new_conversions('test-offer')
      end
    end
  end
end
