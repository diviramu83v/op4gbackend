# frozen_string_literal: true

class CreateSurveyRouterTraffics < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_router_traffics do |t|
      t.integer :survey_router_source_id
      t.string :uid
      t.timestamps
    end
  end
end
