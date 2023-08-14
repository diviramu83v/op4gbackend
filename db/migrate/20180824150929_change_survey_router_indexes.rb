# frozen_string_literal: true

class ChangeSurveyRouterIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :survey_router_sources, :router_id

    add_foreign_key :survey_router_sources, :survey_routers, column: :router_id
    add_foreign_key :surveys, :survey_routers, column: :router_id
    add_foreign_key :onramps, :survey_routers
  end
end
