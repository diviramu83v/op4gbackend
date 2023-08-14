# frozen_string_literal: true

class RenameSurveyRouterVisitTrafficId < ActiveRecord::Migration[5.1]
  def change
    rename_column :survey_router_visits, :survey_router_traffics_id, :survey_router_traffic_id
  end
end
