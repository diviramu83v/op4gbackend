# frozen_string_literal: true

class CreateReturnKeyOnboardings < ActiveRecord::Migration[5.2]
  def change
    create_table :return_key_onboardings do |t|
      t.references :return_key, foreign_key: true
      t.references :onboarding, foreign_key: true

      t.timestamps
    end
  end
end
