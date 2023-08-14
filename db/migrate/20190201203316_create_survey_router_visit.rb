# frozen_string_literal: true

class CreateSurveyRouterVisit < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_router_visits do |t|
      t.references :survey_router_traffics, foreign_key: true, null: false
      t.integer :has_offers_transaction_id, null: false

      t.timestamps
    end

    add_index :survey_router_visits, :has_offers_transaction_id, unique: true
  end
end
