# frozen_string_literal: true

class MakeTrackingPixelCategoryNonNullable < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:tracking_pixels, :category, false)
  end
end
