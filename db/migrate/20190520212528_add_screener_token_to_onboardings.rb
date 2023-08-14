# frozen_string_literal: true

class AddScreenerTokenToOnboardings < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :screener_check_token, :string
    add_index :onboardings, :screener_check_token, unique: true
  end
end
