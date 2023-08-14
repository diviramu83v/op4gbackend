# frozen_string_literal: true

class CreateDecodedDisqoProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :decoded_disqo_projects do |t|
      t.string :disqo_campaign_id
      t.references :survey, foreign_key: true
      t.references :disqo_project_decoding, foreign_key: true, null: false

      t.timestamps
    end
  end
end
