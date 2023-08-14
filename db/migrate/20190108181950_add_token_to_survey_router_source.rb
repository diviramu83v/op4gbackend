# frozen_string_literal: true

class AddTokenToSurveyRouterSource < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_router_sources, :token, :string
    add_index :survey_router_sources, :token, unique: true
  end
end
