# frozen_string_literal: true

class AddResponseTokenToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :response_token, :string
    add_index :onboardings, :response_token, unique: true
    Onboarding.find_each(&:regenerate_response_token)
    change_column_null(:onboardings, :response_token, false)
    add_column :onboardings, :response_page_loaded_at, :datetime
  end
end
