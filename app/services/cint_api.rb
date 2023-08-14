# frozen_string_literal: true

# a service for accessing data from the Cint API
class CintApi
  def initialize
    @url = Settings.cint_api_url
    @auth = { 'X-Api-Key' => Settings.cint_api_key, 'Content-Type' => 'application/*+json', 'Accept' => 'text/json' }
  end

  def create_survey(body:)
    url = "#{@url}/ordering/surveys"
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
    response['id']
  end

  def create_survey_feasibility(body:)
    url = "#{@url}/ordering/feasibilityestimates"
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
    response['feasibilityCount']
  end

  def change_survey_status(survey_id:, status:)
    url = "#{@url}/ordering/surveys/#{survey_id}"
    body = [{ op: 'replace', path: '/status', value: status }]
    response = HTTParty.patch(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def change_survey_cpi(survey_id:, cpi:)
    url = "#{@url}/ordering/surveys/#{survey_id}"
    body = [{ op: 'replace', path: '/cpi/amount', value: cpi }]
    response = HTTParty.patch(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def change_survey_limit(survey_id:, limit:)
    url = "#{@url}/ordering/surveys/#{survey_id}"
    body = [
      { op: 'replace', path: '/limit', value: limit },
      { op: 'replace', path: '/quotaGroups/0/quotas/0/limit', value: limit }
    ]
    response = HTTParty.patch(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def countries_hash(cache: true)
    Rails.cache.fetch('cint_countries_hash', expires_in: 24.hours, force: !cache) do
      url = "#{@url}/ordering/reference/countries"
      response = HTTParty.get(url, headers: @auth)
      check_for_errors(response)
      return if response.body.blank?

      JSON.parse(response.body)
    end
  end

  def country_demo_options(country_id:, cache: false)
    Rails.cache.fetch("cint_country_demo_options/#{country_id}", expires_in: 24.hours, force: !cache) do
      query = { countryId: country_id }
      url = "#{@url}/ordering/reference/questions"
      response = HTTParty.get(url, headers: @auth, query: query)
      check_for_errors(response)
      return if response.body.blank?

      JSON.parse(response.body)
    end
  end

  def record_cint_response(body:)
    url = "#{@url}/fulfillment/respondents/transition"
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def reconcile_rejected_completes(body:)
    url = "#{@url}/fulfillment/respondents/Reconciliations"
    HTTParty.post(url, headers: @auth, body: body.to_json)
  end

  private

  # rubocop:disable Rails/Output
  def check_for_errors(response)
    return if response.code == 201 || response.code == 200

    response['errors']&.each do |error|
      puts "#{error['field']} #{error['message']}"
    end
  end
  # rubocop:enable Rails/Output
end
