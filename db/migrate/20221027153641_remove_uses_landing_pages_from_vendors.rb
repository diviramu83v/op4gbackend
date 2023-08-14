# frozen_string_literal: true

class RemoveUsesLandingPagesFromVendors < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :vendors, :uses_landing_pages, :boolean }
  end
end
