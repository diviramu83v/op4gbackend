# frozen_string_literal: true

class AddOnboardingToEarning < ActiveRecord::Migration[5.1]
  def change
    add_reference :earnings, :onboarding, foreign_key: true
  end
end
