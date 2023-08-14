# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.4'

gem 'rails', '~> 6.1', '>= 6.1.7'
gem 'pg'
gem 'puma', '< 6'
gem 'sass-rails'
gem 'uglifier', '~> 4.2'
gem 'coffee-rails', '~> 5.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rails_sortable'
gem 'turbolinks'
# gem 'jbuilder'

gem 'activerecord-import' # speed up imports
gem 'redis', '< 4.8' # key/value store
gem 'sidekiq', '< 7' # job queues
gem 'sidekiq-failures' # add failures tab to sidekiq UI
gem 'slim' # templating
gem 'font-awesome-sass' # icons
gem 'administrate' # simple admin area
gem 'devise' # user auth and sessions
gem "devise-jwt" # authen by token
gem 'omniauth-facebook' # for logging in via facebook
gem 'omniauth-paypal-oauth2' # for verifying panelist Paypal accounts
gem 'dnsimple' # REVIEW: add DNS records to DNSimple
gem 'platform-api' # REVIEW: add records to Heroku
gem 'prosopite' # detect n + 1 queries
gem 'slack-notifier' # send custom notification to Slack when we deploy
gem 'cancancan' # role authorization
gem 'kaminari' # pagination
gem 'faker', require: false # fake data for seeding
gem 'rubocop-faker'
gem 'dalli' # memcache client
gem 'connection_pool' # support threaded Rails servers using memcachier on heroku
gem 'kt-paperclip' # support nonprofit logos
gem 'aws-sdk-s3' # aws api support for logo storage location
gem 'madmimi' # Madmimi API support for survey invitations
gem 'clockwork', '~> 3.0' # long-running process for generating project reports
gem 'rubyzip', '~> 2.3.2' # project report / Excel downloads
gem 'caxlsx' # project report / Excel downloads
gem 'caxlsx_rails', '~> 0.6.3' # project report / Excel downloads
gem 'lograge', '~> 0.12.0'
gem 'nilify_blanks'
gem 'awesome_print', require: 'ap'
gem 'rest-client'
gem 'barnes'
gem 'httparty' # http service
gem 'rack-cors'
gem 'crawler_detect' # to detect crawler browsers
gem 'money-rails'
gem 'pg_search'
gem 'pg_query'
gem 'image_processing', '~> 1.12', '>= 1.12.2'
gem 'strong_migrations' # support for strong migrations
gem 'active_storage_validations' # support for active storage validations
gem 'hashdiff'
gem 'mimemagic'
gem 'overcommit'
gem 'ruby-ole'
gem 'spreadsheet'

group :development, :test do
  gem 'byebug', platform: :mri

  gem 'dotenv-rails' # manage environment variables
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'

  # This link lists all the versions of rubocop supported by codeclimate.
  # https://github.com/codeclimate/codeclimate-rubocop/branches/all?utf8=%E2%9C%93&query=channel%2Frubocop
  gem 'rubocop', '1.31.0', require: false # keep our code tidy: sync with Code Climate RuboCop channel (.codeclimate.yml)
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'mocha', require: false # add simpler mocks/stubs
  gem 'simplecov', require: false # find holes in our testing
  gem 'simplecov-lcov', require: false
  gem 'webmock', require: false
  gem 'minitest-spec-rails'
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'minitest-rails'
  gem 'minitest-capybara'
  gem 'capybara-email'
  gem 'launchy', require: false
end
