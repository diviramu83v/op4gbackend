# frozen_string_literal: true

class RenameSurveyRouterVisitsHasOffersIdColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :survey_router_visits, :has_offers_id, :visit_code
  end
end
