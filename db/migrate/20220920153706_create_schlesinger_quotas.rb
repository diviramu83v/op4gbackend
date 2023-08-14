# frozen_string_literal: true

class CreateSchlesingerQuotas < ActiveRecord::Migration[6.1]
  def change
    create_table :schlesinger_quotas do |t|
      t.string :name
      t.float :cpi_cents
      t.string :schlesinger_project_id
      t.string :schlesinger_survey_id
      t.string :schlesinger_quota_id
      t.integer :completes_wanted
      t.jsonb :qualifications, default: {}
      t.string :status, default: 'awarded', null: false
      t.integer :loi, null: false
      t.integer :conversion_rate, null: false
      t.integer :soft_launch_completes_wanted
      t.datetime :soft_launch_completed_at
      t.references :survey, foreign_key: true, null: false

      t.timestamps
    end
  end
end
