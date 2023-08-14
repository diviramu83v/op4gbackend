# frozen_string_literal: true

class AddWebhookMethodToVendors < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :webhook_method, :string
    change_column_default :vendors, :webhook_method, from: nil, to: 'post'
  end
end
