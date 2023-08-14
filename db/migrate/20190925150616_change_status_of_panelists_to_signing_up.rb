# frozen_string_literal: true

class ChangeStatusOfPanelistsToSigningUp < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Panelist.active.where(welcomed_at: nil).update_all(status: Panelist.statuses[:signing_up])
  end
  # rubocop:enable Rails/SkipsModelValidations
end
