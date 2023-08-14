# frozen_string_literal: true

class CreateSurveyRouters < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_routers do |t|
      t.string :name, null: false
      t.integer :amount_cents, null: false, default: 0
      t.string :token, null: false

      t.timestamps
    end
  end
end
