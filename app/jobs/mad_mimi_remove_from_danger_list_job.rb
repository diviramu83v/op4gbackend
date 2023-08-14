# frozen_string_literal: true

# Removes a panelist from the nearing deactivation drip campaign.
class MadMimiRemoveFromDangerListJob < ApplicationJob
  queue_as :background

  def perform(panelist:)
    panelist.remove_from_danger_list
  end
end
