# frozen_string_literal: true

# 1 argument: onramp_id
# Usage: rails runner lib/scripts/turn_off_traffic_from_disqo.rb 69010

onramp_id = ARGV[0].to_i
user_name_and_password = "#{Settings.disqo_username}:#{Settings.disqo_password}"

HTTParty.put(
  "https://projects-api.audience.disqo.com/v1/clients/40330/projects/#{onramp_id}/status",
  body: '{"status": "HOLD"}'.to_json,
  headers: {
    'Content-Type' => 'application/json',
    'Authorization' => "Basic #{Base64.strict_encode64(user_name_and_password)}"
  }
)

if response.code == '200'
  puts 'Traffic turned off.'
else
  puts 'Failed to turn off traffic.'
end
