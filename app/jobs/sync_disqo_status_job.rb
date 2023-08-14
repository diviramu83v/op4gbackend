# frozen_string_literal: true

# job to sync the status between our system and disqo
class SyncDisqoStatusJob < ApplicationJob
  queue_as :default

  def perform
    DisqoQuota.live.each(&:sync_status)
  end
end
