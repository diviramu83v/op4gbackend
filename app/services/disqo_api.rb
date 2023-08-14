# frozen_string_literal: true

# a service for accessing data from the DISQO API
class DisqoApi
  def initialize
    @url = Settings.disqo_api_url
    @username = Settings.disqo_username
    password = "#{@username}:#{Settings.disqo_password}"
    @auth = { 'Authorization' => "Basic #{Base64.strict_encode64(password)}", 'Content-Type' => 'application/json' }

    @feasibility_username = Settings.disqo_feasibility_username
    feasibility_password = "#{@feasibility_username}:#{Settings.disqo_feasibility_password}"
    @feasibility_auth = { 'Authorization' => "Basic #{Base64.strict_encode64(feasibility_password)}", 'Content-Type' => 'application/json' }
  end

  def create_project(body: {})
    url = URI(@url + "/v1/clients/#{@username}/projects")
    response = HTTParty.post(url, headers: @auth, body: body)
    check_for_errors(response)
  end

  def update_project(project_id:, body: {})
    url = URI(@url + "/v1/clients/#{@username}/projects/#{project_id}")
    response = HTTParty.put(url, headers: @auth, body: body)
    check_for_errors(response)
  end

  def update_project_status(project_id:, status:)
    url = URI(@url + "/v1/clients/#{@username}/projects/#{project_id}/status")
    body = { status: status }
    response = HTTParty.put(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def create_project_quota(project_id:, body: {})
    url = URI(@url + "/v1/clients/#{@username}/projects/#{project_id}/quotas")
    response = HTTParty.post(url, headers: @auth, body: body)
    check_for_errors(response)
  end

  def update_project_quota(project_id:, quota_id:, body: {})
    url = URI(@url + "/v1/clients/#{@username}/projects/#{project_id}/quotas/#{quota_id}")
    response = HTTParty.put(url, headers: @auth, body: body)
    check_for_errors(response)
  end

  def change_project_quota_status(project_id:, quota_id:, status:)
    url = URI(@url + "/v1/clients/#{@username}/projects/#{project_id}/quotas/#{quota_id}/status")
    body = { status: status }
    response = HTTParty.put(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
  end

  def create_quota_feasibility(body: {})
    url = URI("#{Settings.disqo_api_feasibility_url}/v1/number-of-panelists/")
    response = HTTParty.post(url, headers: @feasibility_auth, body: body)
    check_for_errors(response)
    response
  end

  def get_quota_status(quota:)
    url = URI(@url + "/v1/clients/#{@username}/projects/#{quota.quota_id}/quotas/#{quota.quota_id}")
    response = HTTParty.get(url, headers: @auth)
    return if check_for_errors(response)&.any?

    response['status']
  end

  def get_project_status(quota:)
    url = URI(@url + "/v1/clients/#{@username}/projects/#{quota.quota_id}")
    response = HTTParty.get(url, headers: @auth)
    return if check_for_errors(response)&.any?

    response['status']
  end

  private

  def check_for_errors(response)
    return if response.code == 201 || response.code == 200

    response.parsed_response&.each do |error|
      Rails.logger.error(error['message'])
    end
    response.parsed_response&.map { |error| error['message'] }
  end
end
