# frozen_string_literal: true

class AddDefaultVendorUsesLandingPages < ActiveRecord::Migration[6.1]
  def change
    change_column_default :vendors, :uses_landing_pages, from: nil, to: false
  end
end
