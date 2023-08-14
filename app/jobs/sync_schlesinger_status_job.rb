# frozen_string_literal: true

# job to sync the status between our system and schlesinger
class SyncSchlesingerStatusJob
  include Sidekiq::Worker

  def perform
    SchlesingerQuota.live.each(&:sync_status)
  end
end
