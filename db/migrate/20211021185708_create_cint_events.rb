# frozen_string_literal: true

class CreateCintEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :cint_events do |t|
      t.jsonb :events_data, default: {}

      t.timestamps
    end
  end
end
