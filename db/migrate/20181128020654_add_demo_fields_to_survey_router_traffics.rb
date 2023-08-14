# frozen_string_literal: true

class AddDemoFieldsToSurveyRouterTraffics < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_router_traffics, :age, :integer
    add_column :survey_router_traffics, :gender, :string
  end
end
