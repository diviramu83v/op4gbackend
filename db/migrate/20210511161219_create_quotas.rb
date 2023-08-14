# frozen_string_literal: true

class CreateQuotas < ActiveRecord::Migration[5.2]
  def change
    create_table :quotas do |t|
      t.references :onramp, foreign_key: true, null: false
      t.string :quota_id
      t.float :cpi
      t.integer :completes_wanted
      t.jsonb :qualifications, default: {}

      t.timestamps
    end
  end
end
