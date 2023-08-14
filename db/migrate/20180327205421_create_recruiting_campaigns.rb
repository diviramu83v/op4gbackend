# frozen_string_literal: true

class CreateRecruitingCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :recruiting_campaigns do |t|
      t.string :code, null: false
      t.boolean :incentive_flag, null: false, default: false
      t.integer :incentive_cents
      t.datetime :campaign_started_at
      t.datetime :campaign_stopped_at
      t.integer :max_signups
      t.string :description
      t.boolean :project_zero_flag, null: false, default: false
      t.string :source_label
      t.string :group_name
      t.text :imported_data

      t.timestamps
    end
  end
end
