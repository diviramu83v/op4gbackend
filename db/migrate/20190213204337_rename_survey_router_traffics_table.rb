# frozen_string_literal: true

class RenameSurveyRouterTrafficsTable < ActiveRecord::Migration[5.1]
  def change
    add_index :survey_router_traffics, [:survey_router_source_id, :uid], unique: true
    rename_table :survey_router_traffics, :survey_router_visitors
    rename_column :survey_router_visits, :survey_router_traffic_id, :survey_router_visitor_id
  end
end
