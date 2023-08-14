# frozen_string_literal: true

class CreateCintProjectDecodings < ActiveRecord::Migration[6.1]
  def change
    create_table :cint_project_decodings do |t|
      t.text :cint_campaign_ids
      t.references :employee, foreign_key: true, null: false

      t.timestamps
    end
  end
end
