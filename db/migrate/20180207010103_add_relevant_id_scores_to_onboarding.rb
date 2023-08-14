# frozen_string_literal: true

class AddRelevantIdScoresToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :dupe_score, :integer
    add_column :onboardings, :fraud_profile_score, :integer
    add_column :onboardings, :fraud_flag_count, :integer
  end
end
