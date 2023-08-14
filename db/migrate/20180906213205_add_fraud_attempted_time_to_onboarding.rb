# frozen_string_literal: true

class AddFraudAttemptedTimeToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :fraud_attempted_at, :datetime
  end
end
