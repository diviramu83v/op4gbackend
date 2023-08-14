# frozen_string_literal: true

class AddSurveyRouterSourceIdToOnboardings < ActiveRecord::Migration[5.1]
  def change
    add_reference :onboardings, :survey_router_source, foreign_key: true
  end
end
