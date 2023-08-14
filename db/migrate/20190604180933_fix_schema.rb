# frozen_string_literal: true

class FixSchema < ActiveRecord::Migration[5.1]
  def up
    enable_extension 'pg_stat_statements'

    change_column :surveys, :prevent_overlapping_invitations, :boolean, after: :cpi_cents
    change_column :surveys, :router_id, :integer, after: :prevent_overlapping_invitations
  end
end
