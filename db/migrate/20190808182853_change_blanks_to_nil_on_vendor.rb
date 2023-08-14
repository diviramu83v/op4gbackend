# frozen_string_literal: true

class ChangeBlanksToNilOnVendor < ActiveRecord::Migration[5.1]
  def change
    Vendor.all.each do |vendor|
      vendor.update(complete_url: nil) if vendor.complete_url == ''
      vendor.update(terminate_url: nil) if vendor.terminate_url == ''
      vendor.update(overquota_url: nil) if vendor.overquota_url == ''
      vendor.update(security_url: nil) if vendor.security_url == ''
    end
  end
end
