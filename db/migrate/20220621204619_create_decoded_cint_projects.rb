# frozen_string_literal: true

class CreateDecodedCintProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :decoded_cint_projects do |t|
      t.string :cint_campaign_id
      t.references :survey, foreign_key: true
      t.references :cint_project_decoding, foreign_key: true, null: false

      t.timestamps
    end
  end
end
