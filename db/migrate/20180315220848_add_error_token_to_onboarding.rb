# frozen_string_literal: true

class AddErrorTokenToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :error_token, :string
    add_index :onboardings, :error_token, unique: true
    Onboarding.find_each(&:regenerate_error_token)
    change_column_null(:onboardings, :error_token, false)
  end
end
