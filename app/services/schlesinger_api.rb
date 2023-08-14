# frozen_string_literal: true

# a service for accessing data from the Schlesinger API
class SchlesingerApi # rubocop:disable Metrics/ClassLength
  def initialize
    @demand_url = Settings.schlesinger_demand_api_url
    @definition_url = Settings.schlesinger_definition_api_url
    @auth = { 'X-MC-DEMAND-KEY' => Settings.schlesinger_api_key, 'Content-Type' => 'application/json', 'Cache-Control' => 'no-cache', 'Accept' => 'text/json' }
  end

  def create_project(body: {})
    url = URI("#{@demand_url}/api/v1/project/create")
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['projectId']
  end

  def create_survey(body: {})
    url = URI("#{@demand_url}/api/v1/survey/create")
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['surveyId']
  end

  def change_survey_status(body: {})
    url = "#{@demand_url}/api/v1/survey/update-status"
    response = HTTParty.put(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def update_survey(body: {})
    url = URI("#{@demand_url}/api/v1/survey/update")
    response = HTTParty.put(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def get_survey_status(schlesinger_survey_id:)
    url = URI("#{@demand_url}/api/v1/survey/#{schlesinger_survey_id}")
    response = HTTParty.get(url, headers: @auth)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['surveyStatusId']
  end

  def get_survey_name(schlesinger_survey_id:)
    url = URI("#{@demand_url}/api/v1/survey/#{schlesinger_survey_id}")
    response = HTTParty.get(url, headers: @auth)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['surveyName']
  end

  def create_qualifications(body: {})
    url = URI("#{@demand_url}/api/v1/qualification/create")
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['qualifications']
  end

  def update_qualifications(body: {})
    url = URI("#{@demand_url}/api/v1/qualification/update")
    response = HTTParty.put(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def delete_qualifications(body: {})
    url = URI("#{@demand_url}/api/v1/qualification/delete")
    response = HTTParty.delete(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def create_quota(body: {})
    url = URI("#{@demand_url}/api/v1/quota/create")
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['quotas'].first['surveyQuotaId']
  end

  def update_quota(body: {})
    url = URI("#{@demand_url}/api/v1/quota/update")
    response = HTTParty.put(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def delete_quota(body: {})
    url = URI("#{@demand_url}/api/v1/quota/delete")
    response = HTTParty.delete(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def industries
    url = URI("#{@definition_url}/api/v1/definition/industry-list")
    response = HTTParty.get(url, headers: @auth)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['industries']
  end

  def study_types
    url = URI("#{@definition_url}/api/v1/definition/study-types")
    response = HTTParty.get(url, headers: @auth)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['studyTypes']
  end

  def sample_types
    url = URI("#{@definition_url}/api/v1/definition/sample-types")
    response = HTTParty.get(url, headers: @auth)
    errors = check_for_errors(response)
    return errors if errors.present?

    response['sampleTypes']
  end

  def qualification_answers_for_question(qualification_id)
    url = URI("#{@definition_url}/api/v1/definition/qualification-answers/lanaguge/3/qualification/#{qualification_id}")
    response = HTTParty.get(url, headers: @auth)
    errors = check_for_errors(response)
    return errors if errors.present?

    response.parsed_response['qualifications']
  end

  private

  def check_for_errors(response)
    return if response.code == 201 || response.code == 200

    error = response['appError']['description'] || JSON.parse(response.parsed_response)['errors']
    { errors: error }
  end
end
