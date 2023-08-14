# frozen_string_literal: true

class CreateScreenerChecks < ActiveRecord::Migration[5.1]
  def change
    create_table :screener_checks do |t|
      t.string :gender
      t.string :age_range
      t.string :state
      t.string :income_range
      t.string :ethnicity
      t.string :employment_status
      t.references :onboarding, foreign_key: true, null: false

      t.timestamps
    end
  end
end
