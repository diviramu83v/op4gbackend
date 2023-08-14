# frozen_string_literal: true

class SetStatusesOfPanelists < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    Panelist.where.not(welcomed_at: nil).where(suspended_at: nil, deleted_at: nil).update_all(status: Panelist.statuses[:active])
    Panelist.where.not(suspended_at: nil).update_all(status: Panelist.statuses[:suspended])
    Panelist.where.not(deleted_at: nil).update_all(status: Panelist.statuses[:deleted])
  end
  # rubocop:enable Rails/SkipsModelValidations
end
