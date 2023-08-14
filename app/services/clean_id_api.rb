# frozen_string_literal: true

# a service for interacting with the tango API
class CleanIdApi
  def initialize(transaction_id)
    @url = Settings.clean_id_api_url
    @transaction_id = transaction_id
  end

  def full_set
    url = URI("#{@url}/#{@transaction_id}")
    response = HTTParty.get(url)
    check_for_errors(response)
    response.parsed_response
  end

  private

  def check_for_errors(response)
    return if response.code == 200

    Rails.logger.error(response.parsed_response['message'])
  end
end
# eb815afc-c4eb-47e9-89a8-8981b32f7ca4
