# frozen_string_literal: true

class AddSortOrderToDemoOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :demo_options, :sort_order, :integer, null: false, default: 0
  end
end
