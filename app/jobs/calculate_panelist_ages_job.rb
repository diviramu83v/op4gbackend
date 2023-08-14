# frozen_string_literal: true

# This job will increment the ages of panelists when their records are due for it
# It will also populate "age" and "update_age_at" columns from a birthdate if they are missing
class CalculatePanelistAgesJob < ApplicationJob
  queue_as :default

  def perform
    Panelist.age_needs_updating.find_each(&:calculate_age)
  end
end
