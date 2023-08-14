# frozen_string_literal: true

class CreateCampaignAudiences < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_audiences do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :imported_data

      t.timestamps

      t.timestamps
    end
  end
end
