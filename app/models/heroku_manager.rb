# frozen_string_literal: true

# Abstract the calls to Heroku's PlatformAPI
class HerokuManager
  def initialize
    @app_name = ENV.fetch('HEROKU_APP', 'op4g-staging')
    api = PlatformAPI.connect_oauth(ENV.fetch('HEROKU_PLATFORM_TOKEN', nil))
    @formation = api.formation
  end

  def worker_count
    sidekiq_process['quantity']
  rescue Excon::Error::Timeout
    # do nothing
  end

  def scale_workers(worker_count:)
    result = @formation.update(@app_name, 'worker', quantity: worker_count)
    return if result.blank?

    Rails.logger.info "Heroku worker count updated: #{result['quantity']}"
  end

  private

  def sidekiq_process
    @formation.list(@app_name).find do |process|
      process['command'].include?('sidekiq')
    end
  rescue Excon::Error::Socket
    # do nothing
  end
end
