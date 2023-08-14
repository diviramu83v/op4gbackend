# frozen_string_literal: true

# a service for accessing data from the TUNE API
class TuneApi
  def initialize
    @tune_api_token = ENV.fetch('TUNE_API_TOKEN', nil)
    @url = 'https://op4g.api.hasoffers.com/Apiv3/json'
  end

  def query_affiliate_name(code:)
    query = { NetworkToken: @tune_api_token, Target: 'Affiliate', Method: 'findById', id: code }
    @json_response = Fixie.get(url: @url, query: query)
    return if check_for_errors

    @json_response.parsed_response&.dig('response', 'data', 'Affiliate', 'company')
  end

  # def find_all_affiliates
  #   query = { NetworkToken: @tune_api_token, Target: 'Affiliate', Method: 'findAll' }
  #   @json_response = HTTParty.get(@url, query: query)
  #   return if check_for_errors

  #   @json_response.parsed_response&.dig('response', 'data')
  # end

  def query_offer_name(code:)
    query = { NetworkToken: @tune_api_token, Target: 'Offer', Method: 'findById', id: code }
    @json_response = Fixie.get(url: @url, query: query)
    return if check_for_errors

    @json_response.parsed_response&.dig('response', 'data', 'Offer', 'name')
  end

  # rubocop:disable Metrics/MethodLength
  def find_new_conversions_for_offer(offer_code)
    new_conversions = []
    page = 1
    catch :we_have_all_we_need do
      loop do
        page_conversions = find_all_conversions_for_offer(page: page, offer_code: offer_code)
        throw :we_have_all_we_need if page_conversions.blank?
        page_conversions.each do |conversion|
          throw :we_have_all_we_need if Conversion.find_by(tune_code: conversion['tune_event_id']).present?
          new_conversions << conversion
        end
        page += 1
      end
    end
    new_conversions
  end
  # rubocop:enable Metrics/MethodLength

  private

  # rubocop:disable Metrics/MethodLength
  def find_all_conversions_for_offer(page:, offer_code:)
    query = { NetworkToken: @tune_api_token,
              Target: 'Conversion',
              Method: 'findAll',
              fields: %w[offer_id tune_event_id payout affiliate_id datetime],
              filters: { offer_id: offer_code },
              sort: { datetime: 'desc' },
              page: page,
              limit: 10_000 }

    @json_response = Fixie.get(url: @url, query: query)
    return if check_for_errors
    return if @json_response.parsed_response.dig('response', 'data', 'data').blank?

    @json_response.parsed_response.dig('response', 'data', 'data')&.values&.map { |hash| hash&.dig('Conversion') }
  end
  # rubocop:enable Metrics/MethodLength

  def check_for_errors
    return unless @json_response.parsed_response.dig('response', 'errors').any?

    raise @json_response.parsed_response.dig('response', 'errors').to_s
  end
end
