# frozen_string_literal: true

require 'action_controller'
require 'active_support/configurable'
require 'omniauth/strategies/facebook'

# This module extends the Omniauth Facebook strategy with an additional check
# that takes the place of the omniauth csrf protection gem. It performs the same
# guards, but logs the request, sets an alert, and redirects back to the signup
# view instead of throwing an InvalidAuthenticityToken error.
module OmniauthFacebookStrategy
  def request_phase
    unless AuthenticityTokenChecker.new.call(env)
      env['rack.session']['flash'] =
        ActionDispatch::Flash::FlashHash.new(alert: 'Please try again.')
                                        .to_session_value

      Rails.logger.error 'Omniauth Failure: invalid authenticity token on Facebook OAuth attempt'

      return redirect env['HTTP_REFERER'] || env['HTTP_HOST']
    end

    super
  end
end
