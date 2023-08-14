# frozen_string_literal: true

# A class to handle bad encoded requests
class HandleBadEncodingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      Rack::Utils.parse_nested_query(env['QUERY_STRING'].to_s)
    rescue Rack::QueryParser::InvalidParameterError, ActionController::BadRequest
      req = ActionDispatch::Request.new(env)
      BlockIpAddressJob.perform_later(req.remote_ip, 'Bad encoding middleware')

      env['QUERY_STRING'] = ''
    end
    @app.call(env)
  end
end
