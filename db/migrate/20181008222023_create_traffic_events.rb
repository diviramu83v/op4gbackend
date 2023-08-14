# frozen_string_literal: true

class CreateTrafficEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :traffic_events do |t|
      t.references :onboarding, foreign_key: true, null: false
      t.string :category, null: false
      t.string :message, null: false

      t.timestamps
    end
  end
end
