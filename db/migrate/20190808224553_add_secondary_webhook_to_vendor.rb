# frozen_string_literal: true

class AddSecondaryWebhookToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :send_secondary_webhook, :boolean, null: false, default: false
    add_column :vendors, :secondary_webhook_url, :string
  end
end
