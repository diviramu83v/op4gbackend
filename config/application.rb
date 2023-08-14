# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Platform
end

class Platform::Application < Rails::Application
  # Initialize configuration defaults for originally generated Rails version.
  config.load_defaults 6.1

  # rubocop:disable Rails/FilePath
  config.eager_load_paths << "#{Rails.root}/test/mailers/previews"
  # rubocop:enable Rails/FilePath

  config.exceptions_app = routes
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  config.paperclip_nonprofits = {
    styles: { small: '65x80' },
    default_style: :small,
    convert_options: { all: ['-colorspace', 'sRGB', '-strip'] },
    path: 'np-logos/:id/:style/:filename',
    default_url: 'https://op4g-images.s3.amazonaws.com/np-logos/default_:style.jpg',
    storage: :s3,
    bucket: 'op4g-images',
    s3_protocol: 'https',
    s3_credentials: {
      access_key_id: ENV.fetch('ACCESS_KEY_ID', nil),
      secret_access_key: ENV.fetch('SECRET_ACCESS_KEY', nil)
    },
    s3_region: ENV.fetch('AWS_REGION', nil)
  }

  config.paperclip_campaign_audiences = config.paperclip_nonprofits.merge(path: 'ca-logos/:id/:style/:filename')

  config.paperclip_project_reports = {
    path: 'project_reports/:filename',
    default_url: 'https://op4g-images.s3.amazonaws.com/project_reports/:filename',
    storage: :s3,
    bucket: 'op4g-project-reports',
    s3_protocol: 'https',
    s3_credentials: {
      access_key_id: ENV.fetch('ACCESS_KEY_ID', nil),
      secret_access_key: ENV.fetch('SECRET_ACCESS_KEY', nil)
    },
    s3_region: ENV.fetch('AWS_REGION', nil)
  }

  config.paperclip_traffic_reports = {
    path: 'traffic_reports/:filename',
    default_url: 'https://op4g-images.s3.amazonaws.com/traffic_reports/:filename',
    storage: :s3,
    bucket: 'op4g-traffic-reports',
    s3_protocol: 'https',
    s3_credentials: {
      access_key_id: ENV.fetch('ACCESS_KEY_ID', nil),
      secret_access_key: ENV.fetch('SECRET_ACCESS_KEY', nil)
    },
    s3_region: ENV.fetch('AWS_REGION', nil)
  }

  config.paperclip_panelist_id_cards = {
    path: 'panelist_id_cards/:filename',
    default_url: 'https://op4g-images.s3.amazonaws.com/panelist_id_cards/:filename',
    storage: :s3,
    bucket: 'op4g-panelist-id-cards',
    s3_protocol: 'https',
    s3_credentials: {
      access_key_id: ENV.fetch('ACCESS_KEY_ID', nil),
      secret_access_key: ENV.fetch('SECRET_ACCESS_KEY', nil)
    },
    s3_region: ENV.fetch('AWS_REGION', nil)
  }

  # This setting allows 'data-disable-with' and data: { disable_with: ... } while preventing double submits in Rails 5
  config.action_view.automatically_disable_submit_tag = false

  config.i18n.default_locale = :en
end
