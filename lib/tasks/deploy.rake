# frozen_string_literal: true

require 'dnsimple'
require 'platform-api'

# rubocop:disable Metrics/BlockLength
namespace :deploy do
  desc 'Runs every time the application is deployed.'
  task release: :environment do
    puts "Running deploy:release task: #{Time.now.in_time_zone('Central Time (US & Canada)')}"

    Rake::Task['db:migrate'].invoke
    puts 'DB migrated'

    Rake::Task['db:seed'].invoke
    puts 'DB seeded'
  end

  desc 'Runs only the first time the application is deployed. After the release phase.'
  task bootstrap: :environment do
    puts "Running deploy:bootstrap task: #{Time.now.in_time_zone('Central Time (US & Canada)')}"

    Rake::Task['db:seed'].invoke
    puts 'DB seeded'

    Rake::Task['db:seed:dummy_data'].invoke
    puts 'Dummy seed data added'
  end

  desc 'Set up DNS + Heroku domains.'
  task set_up_domains: :environment do
    heroku_token = ENV.fetch('HEROKU_PLATFORM_TOKEN')
    dnsimple_credentials = { access_token: ENV.fetch('DNSIMPLE_ACCESS_TOKEN') }
    heroku_app_name = ENV.fetch('HEROKU_APP_NAME')
    heroku_app_name =~ /.*(pr-\d+)/

    naked_subdomain    = Regexp.last_match(1) # pr-123
    domain             = 'op4g-staging.com'
    heroku_domain      = "#{domain}.herokudns.com"
    subdomains = %w[admin my testing survey api system]

    begin
      # Add DNS records.
      begin
        client = Dnsimple::Client.new(dnsimple_credentials)
        whoami = client.identity.whoami.data
        account_id = whoami.account.id

        client.zones.create_record(
          account_id,
          'op4g-staging.com',
          name: naked_subdomain,
          type: 'CNAME',
          content: [naked_subdomain, heroku_domain].join('.')
        )
        puts 'Created naked domain DNS entry'

        subdomains.each do |subdomain|
          client.zones.create_record(
            account_id,
            'op4g-staging.com',
            name: [subdomain, naked_subdomain].join('.'),
            type: 'CNAME',
            content: [subdomain, naked_subdomain, heroku_domain].join('.')
          )
          puts "Created #{subdomain} DNS entry"
        end
      rescue Dnsimple::RequestError
        puts 'DNSimple records already created'
      end

      # Add Heroku records.
      begin
        heroku = PlatformAPI.connect_oauth(heroku_token)

        heroku.domain.create(heroku_app_name, hostname: [naked_subdomain, domain].join('.'))
        puts 'Created naked domain Heroku entry'

        subdomains.each do |subdomain|
          heroku.domain.create(heroku_app_name, hostname: [subdomain, naked_subdomain, domain].join('.'))
          puts 'Created subdomain Heroku entry'
        end
      rescue Excon::Error::NotFound
        puts 'Heroku records already created'
      end
    rescue StandardError => e
      puts "Error deploying temporary DNS records: #{e}"
    end
  end
end
# rubocop:enable Metrics/BlockLength
