# frozen_string_literal: true

class CreatePanelistEncodings < ActiveRecord::Migration[5.1]
  def change
    create_table :panelist_encodings do |t|
      t.references :survey, foreign_key: true, null: false
      t.references :panelist, foreign_key: true, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :panelist_encodings, [:survey_id, :panelist_id], unique: true
  end
end
