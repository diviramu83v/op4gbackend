# frozen_string_literal: true

class AddIndexOnCategories < ActiveRecord::Migration[5.1]
  def change
    add_index :tracking_pixels, :category
    add_index :panels, :category
    add_index :traffic_events, :category
  end
end
