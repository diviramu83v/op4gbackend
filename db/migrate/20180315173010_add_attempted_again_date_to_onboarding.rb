# frozen_string_literal: true

class AddAttemptedAgainDateToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :attempted_again_at, :datetime
  end
end
