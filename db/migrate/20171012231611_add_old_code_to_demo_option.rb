# frozen_string_literal: true

class AddOldCodeToDemoOption < ActiveRecord::Migration[5.1]
  def change
    add_column :demo_options, :old_code, :string
  end
end
