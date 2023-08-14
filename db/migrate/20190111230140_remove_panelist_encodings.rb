# frozen_string_literal: true

class RemovePanelistEncodings < ActiveRecord::Migration[5.1]
  def change
    drop_table :panelist_encodings do |t|
      t.bigint 'survey_id', null: false
      t.bigint 'panelist_id', null: false
      t.string 'token', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
  end
end
