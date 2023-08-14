# frozen_string_literal: true

# This job removes old system records.
class DataCleanupJob < ApplicationJob
  queue_as :default

  def perform
    SystemEvent.summarize_and_delete_old_data(before_day: Time.now.utc - 90.days)
    ProjectInvitation.delete_stale_records
    Survey.delete_old_keys
    Survey.clean_stale_invitations
  end
end
