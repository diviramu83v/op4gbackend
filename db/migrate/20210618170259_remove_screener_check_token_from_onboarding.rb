# frozen_string_literal: true

class RemoveScreenerCheckTokenFromOnboarding < ActiveRecord::Migration[5.2]
  def change
    remove_column :onboardings, :screener_check_token, :string
  end
end
