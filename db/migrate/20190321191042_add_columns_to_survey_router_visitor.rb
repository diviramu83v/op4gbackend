# frozen_string_literal: true

class AddColumnsToSurveyRouterVisitor < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_router_visitors, :income, :integer
    add_column :survey_router_visitors, :state, :string
  end
end
