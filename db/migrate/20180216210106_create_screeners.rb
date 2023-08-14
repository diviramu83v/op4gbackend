# frozen_string_literal: true

class CreateScreeners < ActiveRecord::Migration[5.1]
  def change
    create_table :screeners do |t|
      t.references :campaign, foreign_key: true, null: false
      t.string :outbound_url

      t.timestamps
    end
  end
end
