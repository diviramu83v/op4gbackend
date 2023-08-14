# frozen_string_literal: true

class AddMarkedFraudAtToOnboarding < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :marked_fraud_at, :datetime
  end
end
