# frozen_string_literal: true

require 'test_helper'

class CintApiTest < ActiveSupport::TestCase
  setup do
    @url = Settings.disqo_api_url
    @client_id = Settings.disqo_username
  end

  describe '#create survey' do
    it 'should create a survey' do
      stub_request(:post, 'https://fuse.cint.com/ordering/surveys').to_return(status: 200)

      assert_nil CintApi.new.create_survey(body: {})
    end
  end

  describe '#create cint feasibility' do
    it 'should create a feasibility' do
      stub_request(:post, 'https://fuse.cint.com/ordering/feasibilityestimates').to_return(status: 200)

      assert_nil CintApi.new.create_survey_feasibility(body: {})
    end
  end

  describe '#record_cint_response' do
    it 'should record an onboarding response on cint' do
      stub_request(:post, "#{Settings.cint_api_url}/fulfillment/respondents/transition")
        .to_return(status: 200)

      assert_nil CintApi.new.record_cint_response(body: {})
    end
  end

  describe '#countries_hash' do
    it 'should return the countries hash' do
      stub_request(:get, "#{Settings.cint_api_url}/ordering/reference/countries")
        .to_return(status: 200)

      response = CintApi.new.countries_hash
      assert response.blank?
    end
  end

  describe '#country_demo_options' do
    it 'should return the countries hash' do
      stub_request(:get, "#{Settings.cint_api_url}/ordering/reference/questions?countryId=22")
        .to_return(status: 200)

      response = CintApi.new.country_demo_options(country_id: 22)
      assert response.blank?
    end
  end
end
