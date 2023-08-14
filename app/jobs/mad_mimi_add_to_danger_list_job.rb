# frozen_string_literal: true

# Adds a panelist who might be deactivated to a drip campaign list in Mad Mimi.
class MadMimiAddToDangerListJob < ApplicationJob
  queue_as :background

  def perform(panelist:)
    panelist.add_to_danger_list
  end
end
