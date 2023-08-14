# frozen_string_literal: true

require 'test_helper'

class TuneApiTest < ActiveSupport::TestCase
  # describe '#query_affiliate_name' do
  #   it 'returns the name of the affiliate' do
  #     stub_request(:get, /op4g.api.hasoffers.com/).to_return(status: 200,
  #                                                            body: { 'response': {
  #                                                              'data': { 'Affiliate': { 'company': 'Test Name' } },
  #                                                              'errors': [] } }.to_json,
  #                                                            headers: { 'Content-Type': 'application/json' })
  #     assert_equal TuneApi.new.query_affiliate_name(code: '373'), 'Test Name'
  #   end
  # end

  describe '#find_new_conversions' do
    it 'returns new conversions we haven\'t processed yet' do
      first_response = {
        status: 200,
        body: {
          response: {
            data: {
              data: {
                '1': {
                  Conversion: { tune_event_id: '1', offer_id: '789', payout: '8.00' }
                },
                '2': {
                  Conversion: { tune_event_id: '2', offer_id: '789', payout: '8.00' }
                }
              }
            },
            errors: []
          }
        }.to_json,
        headers: { 'Content-Type': 'application/json' }
      }

      second_response = {
        status: 200,
        body: {
          response: {
            data: {
              data: {
                '3': {
                  Conversion: { tune_event_id: '3', offer_id: '789', payout: '8.00' }
                },
                '5555': {
                  Conversion: { tune_event_id: '5555', offer_id: '789', payout: '8.00' }
                }
              }
            },
            errors: []
          }
        }.to_json,
        headers: { 'Content-Type': 'application/json' }
      }

      stub_request(:get, /op4g.api.hasoffers.com/).to_return(first_response, second_response)

      assert_equal 3, TuneApi.new.find_new_conversions_for_offer(Offer.first.code).count

      assert(TuneApi.new.find_new_conversions_for_offer(Offer.first.code).none? do |c|
               Conversion.find_by(tune_code: c['tune_event_id']).present?
             end)
    end

    it 'runs into some sort of error probably rate limiting' do
      error_response = {
        status: 200,
        body: {
          response: {
            errors: ['Rate limit has been reached']
          }
        }.to_json,
        headers: { 'Content-Type': 'application/json' }
      }

      stub_request(:get, /op4g.api.hasoffers.com/).to_return(error_response)

      assert_raises RuntimeError do
        TuneApi.new.find_new_conversions_for_offer(Offer.first.code)
      end
    end
  end
end
