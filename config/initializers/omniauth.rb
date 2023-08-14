# frozen_string_literal: true

# prevents error output from reaching the console during the test suite
OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = proc do |env|
  query_hash = env['rack.request.query_hash'] || {}

  Rails.logger.error "Omniauth Failure: #{query_hash}" unless query_hash['error_reason'] == 'user_denied'

  Panelist::BaseController.action(:omniauth_failure).call(env)
end
