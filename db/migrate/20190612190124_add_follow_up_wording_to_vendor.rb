# frozen_string_literal: true

class AddFollowUpWordingToVendor < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :follow_up_wording, :text
  end
end
