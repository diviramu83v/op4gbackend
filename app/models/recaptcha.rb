# frozen_string_literal: true

# ReCaptcha validates Google recaptcha values.
class Recaptcha
  def initialize(request, secret)
    @request = request
    @secret = secret
  end

  # rubocop:disable Metrics/MethodLength
  def token_valid?(token)
    return false if token.blank?

    begin
      response =
        HTTParty.post(
          'https://www.google.com/recaptcha/api/siteverify',
          {
            body: "secret=#{@secret}&response=#{token}&remoteip=#{@request.ip}",
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded',
              'charset' => 'utf-8'
            }
          }
        )

      data = JSON.parse(response.body)

      # success must be true and host must match
      return data['success'].to_s == 'true' && data['hostname'] == @request.host
    rescue JSON::ParserError
      Rails.logger.info "Error caught: Unable to parse JSON returned by Recaptcha service: #{response.body}"
    rescue Net::OpenTimeout, Net::ReadTimeout, OpenSSL::SSL::SSLError => e
      Rails.logger.info "Error caught: #{e.message}"
    end

    false
  end
  # rubocop:enable Metrics/MethodLength

  def token_invalid?(token)
    !token_valid?(token)
  end
end
