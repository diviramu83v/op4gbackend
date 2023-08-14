# frozen_string_literal: true

class CreateKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :keys do |t|
      t.references :project, foreign_key: true, null: false
      t.references :campaign, foreign_key: true, null: false
      t.string :value, null: false

      t.timestamps
    end
  end
end
