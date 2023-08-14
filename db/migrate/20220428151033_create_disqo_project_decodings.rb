# frozen_string_literal: true

class CreateDisqoProjectDecodings < ActiveRecord::Migration[5.2]
  def change
    create_table :disqo_project_decodings do |t|
      t.text :disqo_campaign_ids
      t.references :employee, foreign_key: true, null: false

      t.timestamps
    end
  end
end
