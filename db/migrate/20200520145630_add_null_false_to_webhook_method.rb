# frozen_string_literal: true

class AddNullFalseToWebhookMethod < ActiveRecord::Migration[5.2]
  def change
    change_column_null :vendors, :webhook_method, false
  end
end
