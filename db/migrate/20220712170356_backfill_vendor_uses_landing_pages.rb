# frozen_string_literal: true

class BackfillVendorUsesLandingPages < ActiveRecord::Migration[6.1]
  def change
    Vendor.where(uses_landing_pages: nil).find_each do |vendor|
      vendor.update!(uses_landing_pages: false)
    end
  end
end
