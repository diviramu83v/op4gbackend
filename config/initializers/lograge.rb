# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.custom_options = lambda do |event|
    next if event.payload[:params].blank?

    {
      remote_ip: event.payload[:remote_ip],
      request_id: event.payload[:request_id],
      host: event.payload[:host],
      user: event.payload[:user],
      long_request: event.duration > ENV['LONG_REQUEST_DURATION'].to_i
    }.merge(event.payload[:params].except('controller', 'action', 'format', 'utf8', 'subdomain', 'tld_length'))
  end
end
