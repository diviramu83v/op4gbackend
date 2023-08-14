# frozen_string_literal: true

class CreateTrackingPixels < ActiveRecord::Migration[5.1]
  def change
    create_table :tracking_pixels do |t|
      t.string :url, null: false

      t.timestamps
    end
  end
end
