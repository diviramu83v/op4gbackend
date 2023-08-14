# frozen_string_literal: true

class ChangeSurveyVisitHasOffersColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :survey_router_visits, :has_offers_transaction_id, :has_offers_id
  end
end
