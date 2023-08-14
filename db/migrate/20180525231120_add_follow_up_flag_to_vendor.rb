# frozen_string_literal: true

class AddFollowUpFlagToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :collect_followup_data, :boolean, null: false, default: false
  end
end
