# frozen_string_literal: true

class AddDescriptionToTrackingPixels < ActiveRecord::Migration[5.1]
  def change
    add_column :tracking_pixels, :description, :string
  end
end
