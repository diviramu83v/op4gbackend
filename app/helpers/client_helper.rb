# frozen_string_literal: true

# View helpers for client pages and cards.
module ClientHelper
  def client_link(client)
    return '?' if client.blank?

    # TODO: Check permissions with cancancan here. (link_to_if)
    link_to client.name, client
  end

  def format_parameters_for_client_list(client)
    output = []

    output << "uid: #{client.custom_uid_parameter}" if client.custom_uid_parameter.present?
    output << "key: #{client.custom_key_parameter}" if client.custom_key_parameter.present?

    output.join(' / ')
  end
end
