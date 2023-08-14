# frozen_string_literal: true

class ReactivatePanelistsForOplusAndOp4g < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Panel.where(name: %w[Op4G OPlus]).find_each do |panel|
      panel.panelists.where(status: Panelist.statuses[:deactivated]).update_all(status: Panelist.statuses[:active], last_activity_at: Time.now.utc)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
