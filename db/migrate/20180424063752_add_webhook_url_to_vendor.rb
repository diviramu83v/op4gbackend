# frozen_string_literal: true

class AddWebhookUrlToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :webhook_url, :string
  end
end
