# frozen_string_literal: true

class AddRelevantIdColumnsToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :relevant_id_started_at, :datetime
    add_column :onboardings, :relevant_id_passed_at, :datetime
    add_column :onboardings, :relevant_id_failed_at, :datetime
  end
end
