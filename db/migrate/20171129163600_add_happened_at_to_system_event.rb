# frozen_string_literal: true

class AddHappenedAtToSystemEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :system_events, :happened_at, :datetime, null: false
  end
end
