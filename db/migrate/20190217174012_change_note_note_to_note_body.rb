# frozen_string_literal: true

class ChangeNoteNoteToNoteBody < ActiveRecord::Migration[5.1]
  def change
    rename_column :panelist_notes, :note, :body
    change_column :panelist_notes, :body, :string, null: false
  end
end
