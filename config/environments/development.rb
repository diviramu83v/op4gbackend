# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # rubocop:disable Rails/FilePath
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
  # rubocop:enable Rails/FilePath

  # Set default URL of Devise mailer
  config.action_mailer.default_url_options = { host: 'admin.op4g.local', port: 3000 }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  # Send mail to mailcatcher port.
  # See https://mailcatcher.me for more info.
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
  config.asset_host = 'http://admin.op4g.local:3000/'

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Turn off asset and helper generators
  config.generators.assets = false
  config.generators.helper = false

  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', :debug).to_sym

  # Disables DNS rebinding protection
  config.hosts.clear

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Paperclip configuration
  Paperclip.options[:command_path] = '/usr/local/bin/'

  config.after_initialize do
    Prosopite.rails_logger = true
  end
end
# rubocop:enable Metrics/BlockLength
