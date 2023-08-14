# frozen_string_literal: true

class AddUniqueIndexToTrackingPixels < ActiveRecord::Migration[5.1]
  def change
    add_index :tracking_pixels, :url, unique: true
  end
end
