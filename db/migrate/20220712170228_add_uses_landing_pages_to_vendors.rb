# frozen_string_literal: true

class AddUsesLandingPagesToVendors < ActiveRecord::Migration[6.1]
  def change
    add_column :vendors, :uses_landing_pages, :boolean
  end
end
