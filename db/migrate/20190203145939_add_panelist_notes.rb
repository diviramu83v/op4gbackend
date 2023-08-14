# frozen_string_literal: true

class AddPanelistNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :panelist_notes do |t|
      t.integer :panelist_id, null: false
      t.integer :employee_id, null: false
      t.string :note

      t.timestamps
    end

    add_foreign_key :panelist_notes, :panelists
    add_foreign_key :panelist_notes, :employees
  end
end
