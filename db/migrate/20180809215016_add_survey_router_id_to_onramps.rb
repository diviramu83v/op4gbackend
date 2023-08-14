# frozen_string_literal: true

class AddSurveyRouterIdToOnramps < ActiveRecord::Migration[5.1]
  def change
    add_column :onramps, :survey_router_id, :integer
  end
end
