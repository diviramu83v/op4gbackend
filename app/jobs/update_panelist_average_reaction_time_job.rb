# frozen_string_literal: true

# This job updates the panelist average_reaction_time field.
class UpdatePanelistAverageReactionTimeJob < ApplicationJob
  queue_as :default

  # rubocop:disable Rails/SkipsModelValidations
  def perform
    Panelist.all.find_each do |panelist|
      panelist.update_columns(average_reaction_time: panelist.avg_reaction_time) if panelist.avg_reaction_time.is_a?(Numeric)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
