# frozen_string_literal: true

class ChangeSurveyRouterVisitorIncome < ActiveRecord::Migration[5.1]
  def change
    remove_column :survey_router_visitors, :income, :integer
    add_column :survey_router_visitors, :income, :string
  end
end
