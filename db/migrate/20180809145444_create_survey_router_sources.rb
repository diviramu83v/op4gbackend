# frozen_string_literal: true

class CreateSurveyRouterSources < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_router_sources do |t|
      t.integer :router_id, null: false
      t.string :uid, null: false
      t.timestamps
    end
  end
end
