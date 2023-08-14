# frozen_string_literal: true

class ReverseRelationshipBetweenSurveysAndSurveyRouters < ActiveRecord::Migration[5.1]
  def up
    remove_column :survey_routers, :survey_id
    add_column :surveys, :router_id, :integer
  end

  def down
    remove_column :surveys, :router_id
    add_column :survey_routers, :survey_id, null: false
  end
end
