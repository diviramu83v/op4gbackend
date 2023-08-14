# frozen_string_literal: true

class CreateDemographicDetailResults < ActiveRecord::Migration[5.2]
  def change
    create_table :demographic_detail_results do |t|
      t.references :demographic_detail, null: false, foreign_key: true
      t.text :uid, null: false
      t.references :panelist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
