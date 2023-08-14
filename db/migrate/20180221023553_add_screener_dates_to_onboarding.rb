# frozen_string_literal: true

class AddScreenerDatesToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :screener_started_at, :datetime
    add_column :onboardings, :screener_passed_at, :datetime
    add_column :onboardings, :screener_failed_at, :datetime
  end
end
