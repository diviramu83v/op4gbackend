# frozen_string_literal: true

class AddSurveyIdToSurveyRouters < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_routers, :survey_id, :integer, null: false
    add_index :survey_routers, :survey_id
  end
end
