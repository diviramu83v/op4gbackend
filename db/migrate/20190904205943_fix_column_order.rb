# frozen_string_literal: true

class FixColumnOrder < ActiveRecord::Migration[5.1]
  def change
    change_column :surveys, :prevent_overlapping_invitations, :boolean, after: :cpi_cents
    change_column :surveys, :router_id, :integer, after: :prevent_overlapping_invitations
  end
end
