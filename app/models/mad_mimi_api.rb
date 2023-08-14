# frozen_string_literal: true

# Wrapper class for the MadMimi API plugin
class MadMimiApi
  CREDENTIALS = {
    api_key: ENV.fetch('MIMI_MAILER_API_KEY', nil),
    username: ENV.fetch('MIMI_USERNAME', nil)
  }.freeze

  def add_to_list(email:, list_id:)
    update_list(email, list_id, 'add')
  end

  def remove_from_list(email:, list_id:)
    update_list(email, list_id, 'remove')
  end

  def suppress_all_communication(email:)
    post(
      "https://madmimi.com/audience_members/#{email}/suppress_email",
      CREDENTIALS
    )
  end

  private

  def update_list(email, list_id, action)
    post(
      "https://madmimi.com/audience_lists/#{list_id}/#{action}",
      CREDENTIALS.merge(email: email)
    )
  end

  def post(url, options)
    unless FeatureManager.send_real_mimi_emails? # don't make the call unless this is test or production
      Rails.logger.info('Skipping Mad Mimi API call for non-production environment')
      return
    end

    @response = HTTParty.post(url, query: options)

    # Silently exit if email is not found
    return if email_not_found

    raise "ERROR: MadMimiApi: #{@response.inspect}" unless @response.code == 200
  end

  def email_not_found
    @response.code == 400 && @response.parsed_response.include?('does not exist')
  end
end
