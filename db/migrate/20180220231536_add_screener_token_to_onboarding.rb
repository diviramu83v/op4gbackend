# frozen_string_literal: true

class AddScreenerTokenToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :screener_token, :string
    add_index :onboardings, :screener_token, unique: true

    Onboarding.find_each(&:regenerate_screener_token)

    change_column_null(:onboardings, :screener_token, false)
  end
end
