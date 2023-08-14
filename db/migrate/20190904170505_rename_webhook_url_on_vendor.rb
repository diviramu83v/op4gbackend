# frozen_string_literal: true

class RenameWebhookUrlOnVendor < ActiveRecord::Migration[5.1]
  def change
    rename_column :vendors, :webhook_url, :complete_webhook_url
  end
end
