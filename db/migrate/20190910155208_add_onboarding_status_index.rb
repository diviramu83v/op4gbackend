# frozen_string_literal: true

class AddOnboardingStatusIndex < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    add_index :onboardings, :status, algorithm: :concurrently
  end
end
