# frozen_string_literal: true

class RemoveOnboardingIdColumnFromScreenerCheck < ActiveRecord::Migration[5.2]
  def change
    remove_column :screener_checks, :onboarding_id, :bigint
  end
end
