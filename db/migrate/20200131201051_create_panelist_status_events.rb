# frozen_string_literal: true

class CreatePanelistStatusEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :panelist_status_events do |t|
      t.references :panelist, foreign_key: true, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
