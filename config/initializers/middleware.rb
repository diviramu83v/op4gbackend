# frozen_string_literal: true

require_relative '../../lib/middleware/handle_bad_encoding_middleware'
require_relative '../../lib/middleware/omniauth_facebook_strategy'

# Be sure to restart your server when you modify this file.

# Platform::Application.config.middleware.use HandleMiddlewareErrors

Platform::Application.config.middleware.use Rack::CrawlerDetect
Platform::Application.config.middleware.insert_before Rack::Runtime, HandleBadEncodingMiddleware

OmniAuth::Strategies::Facebook.prepend(OmniauthFacebookStrategy)

Platform::Application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(/^(http:|https:).*(op4g\.local:3000|op4g-staging\.com|op4g\.com).*$/)
    resource "*",
      headers: %w(Authorization),
      expose: %w(Authorization),
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
