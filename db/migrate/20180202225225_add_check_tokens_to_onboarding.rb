# frozen_string_literal: true

class AddCheckTokensToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :relevant_id_token, :string, null: false
    add_column :onboardings, :recaptcha_token, :string, null: false
    add_column :onboardings, :gate_survey_token, :string, null: false

    add_index :onboardings, :token, unique: true
    add_index :onboardings, :relevant_id_token, unique: true
    add_index :onboardings, :recaptcha_token, unique: true
    add_index :onboardings, :gate_survey_token, unique: true
  end
end
