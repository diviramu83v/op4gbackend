# frozen_string_literal: true

class AddOnboardingTokenToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :onboarding_token, :string
    add_index :onboardings, :onboarding_token, unique: true
  end
end
