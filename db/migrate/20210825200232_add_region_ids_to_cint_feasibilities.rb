# frozen_string_literal: true

class AddRegionIdsToCintFeasibilities < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :cint_feasibilities, :region_ids, :text, default: [], array: true
  end
end
