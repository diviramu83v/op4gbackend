# frozen_string_literal: true

class RemoveOnboardingCompletedColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :onboardings, :completed_at, :datetime
  end
end
