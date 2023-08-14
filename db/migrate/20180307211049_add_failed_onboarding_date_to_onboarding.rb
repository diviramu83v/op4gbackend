# frozen_string_literal: true

class AddFailedOnboardingDateToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :failed_onboarding_at, :datetime
  end
end
