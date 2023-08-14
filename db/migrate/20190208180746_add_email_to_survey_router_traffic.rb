# frozen_string_literal: true

class AddEmailToSurveyRouterTraffic < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_router_traffics, :email, :string
  end
end
