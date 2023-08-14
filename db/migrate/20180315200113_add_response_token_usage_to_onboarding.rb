# frozen_string_literal: true

class AddResponseTokenUsageToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :response_token_used_at, :datetime
  end
end
