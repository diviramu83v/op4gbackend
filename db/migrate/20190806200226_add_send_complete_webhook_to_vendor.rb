# frozen_string_literal: true

class AddSendCompleteWebhookToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :send_complete_webhook, :boolean, null: false, default: false
  end
end
