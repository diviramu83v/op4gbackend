# frozen_string_literal: true

require 'barnes'

workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))

threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV.fetch('PORT', 3000)
environment ENV.fetch('RACK_ENV', 'development')

if ENV.fetch('RAILS_ENV', nil) == 'development'
  Rails.logger.info 'Development environment detected: setting worker_timeout to 3600 seconds.'
  worker_timeout 3600
end

before_fork do
  Barnes.start
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
