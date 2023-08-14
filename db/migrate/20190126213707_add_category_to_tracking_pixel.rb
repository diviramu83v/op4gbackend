# frozen_string_literal: true

class AddCategoryToTrackingPixel < ActiveRecord::Migration[5.1]
  def change
    add_column :tracking_pixels, :category, :string
  end
end
