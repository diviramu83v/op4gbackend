# frozen_string_literal: true

# This job will look for panelists that have not logged in
# within a certain period and will deactivate them
class DeactivateStalePanelistsJob < ApplicationJob
  queue_as :default

  def perform
    Panelist.deactivate_stale_panelists
  end
end
