# frozen_string_literal: true

class AddGateSurveyTableAndVendorBatchGate < ActiveRecord::Migration[5.1]
  def change
    create_table :gate_surveys do |t|
      t.string :state
      t.string :zip
      t.date :birthdate
      t.integer :age
      t.string :gender
      t.string :income
      t.string :ethnicity
      t.integer :onboarding_id

      t.timestamps
    end

    add_foreign_key :gate_surveys, :onboardings
  end
end
