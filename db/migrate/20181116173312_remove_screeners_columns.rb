# frozen_string_literal: true

class RemoveScreenersColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :onboardings, :screener_token
    remove_column :onboardings, :screener_started_at
    remove_column :onboardings, :screener_passed_at
    remove_column :onboardings, :screener_failed_at

    remove_column :onramps, :use_screener
  end
end
