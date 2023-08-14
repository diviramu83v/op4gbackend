# frozen_string_literal: true

require 'test_helper'

class ApiTokenTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      api_token = api_tokens(:standard)
      assert api_token.valid?
      assert_empty api_token.errors
    end
  end

  describe 'validations' do
    setup do
      @api_token = api_tokens(:standard)
    end

    it 'is invalid with no status' do
      @api_token.update(status: nil)
      assert_not @api_token.valid?
      @api_token.update(status: '')
      assert_not @api_token.valid?
    end

    it 'is invalid with no description' do
      @api_token.update(description: nil)
      assert_not @api_token.valid?
      @api_token.update(description: '')
      assert_not @api_token.valid?
    end
  end

  describe 'onramp creation' do
    setup do
      @vendor = vendors(:batch)
      @survey_api_target = survey_api_targets(:standard)
    end

    describe 'active token' do
      setup do
        @survey_api_target.update!(status: 'active')
      end

      test 'creates a new onramp' do
        assert_difference 'Onramp.api.count' do
          @token = api_tokens(:standard)
          @token.update(vendor: @vendor)
        end
        assert_equal @token.vendor, Onramp.last.vendor
      end
    end

    describe 'sandbox token' do
      setup do
        @survey_api_target.update!(status: 'sandbox')
      end

      test 'creates a new onramp' do
        assert_difference 'Onramp.api.count' do
          @token = api_tokens(:sandbox)
          @token.update(vendor: @vendor)
        end
        assert_equal @token.vendor, Onramp.last.vendor
      end
    end
  end

  describe '#limited?' do
    setup do
      @api_token = api_tokens(:standard)
    end

    it 'returns true when > X requests per hour' do
      75.times do
        SystemEvent.create(
          description: 'test description',
          happened_at: Time.now.utc.beginning_of_day,
          api_token: @api_token
        )
      end
      assert @api_token.limited?
    end

    it 'returns false when < X requests per hour' do
      45.times do
        SystemEvent.create(
          description: 'test description',
          happened_at: Time.now.utc.beginning_of_day,
          api_token: @api_token
        )
      end
      assert_not @api_token.limited?
    end
  end
end
