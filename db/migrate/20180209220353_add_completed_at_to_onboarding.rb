# frozen_string_literal: true

class AddCompletedAtToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :completed_at, :datetime
  end
end
