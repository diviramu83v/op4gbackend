# frozen_string_literal: true

# a service for interacting with the tango API
class TangoApi
  def initialize
    @url = Settings.tango_api_url
    username = Settings.tango_platform_name
    password = Settings.tango_platform_key
    credentials = "#{username}:#{password}"
    @auth = { 'Authorization' => "Basic #{Base64.strict_encode64(credentials)}", 'Content-Type' => 'application/json' }
  end

  def create_order(body:)
    url = URI("#{@url}/v2/orders")
    response = HTTParty.post(url, headers: @auth, body: body.to_json)
    check_for_errors(response)
    response
  end

  def account
    url = URI("#{@url}/v2/accounts/A85728620")
    response = HTTParty.get(url, headers: @auth)
    check_for_errors(response)
    response['currentBalance']
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
