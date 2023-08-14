# frozen_string_literal: true

# The app config is pulled into this class in order to provide the correct context
# for verfied_request?. Besides that, this class checks the request (via the env hash)
# to make sure it's not a potential CSRF request. Specifically, the request will be
# a POST request (GET requests are treated as indempotent/harmless by Omniauth, but this
# one is decidedly not!) and that request will have a verifiable authenticity token.
class AuthenticityTokenChecker
  include ActiveSupport::Configurable
  include ActionController::RequestForgeryProtection

  # load the app config (correct context for 'verified_request?')
  config.each_key do |configuration_name|
    undef_method configuration_name
    define_method configuration_name do
      ActionController::Base.config[configuration_name]
    end
  end

  # check if a request (in env form) has a valid authenticity token
  def call(env)
    @request = ActionDispatch::Request.new(env.dup)

    verified_request? && env['REQUEST_METHOD'] == 'POST'
  end

  private

  # populate the variables that 'verfied_request?' is expecting
  attr_reader :request

  delegate :params, :session, to: :request
end
