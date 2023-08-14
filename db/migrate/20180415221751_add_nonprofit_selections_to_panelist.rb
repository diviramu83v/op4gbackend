# frozen_string_literal: true

class AddNonprofitSelectionsToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_reference :panelists, :nonprofit, foreign_key: true
    add_reference :panelists, :original_nonprofit, foreign_key: { to_table: :nonprofits }
    add_column :panelists, :supports_npom, :boolean, null: false, default: false
  end
end
