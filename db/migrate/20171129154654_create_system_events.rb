# frozen_string_literal: true

class CreateSystemEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :system_events do |t|
      t.text :description, null: false

      t.timestamps
    end
  end
end
