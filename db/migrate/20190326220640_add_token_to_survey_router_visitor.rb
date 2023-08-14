# frozen_string_literal: true

class AddTokenToSurveyRouterVisitor < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_router_visitors, :token, :string
    add_index :survey_router_visitors, :token, unique: true
  end
end
