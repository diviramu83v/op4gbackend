# frozen_string_literal: true

class BackfillVendorWebhookMethod < ActiveRecord::Migration[5.2]
  def change
    return unless table_exists?(:vendors)
    return unless column_exists?(:vendors, :webhook_method)

    Vendor.find_in_batches do |vendors|
      vendors.each { |v| v.update(webhook_method: 'post') }
    end
  end
end
