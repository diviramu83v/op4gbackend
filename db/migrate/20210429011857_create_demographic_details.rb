# frozen_string_literal: true

class CreateDemographicDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :demographic_details do |t|
      t.text :encoded_uids
      t.references :panel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
