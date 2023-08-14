# frozen_string_literal: true

class AddOnboardingToReturnKey < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  safety_assured

  def change
    add_column :return_keys, :onboarding_id, :bigint
    add_foreign_key :return_keys, :onboardings, column: :onboarding_id
    add_index :return_keys, :onboarding_id, unique: true
  end
end
