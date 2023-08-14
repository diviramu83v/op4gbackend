# frozen_string_literal: true

class AddPayoutToApiTarget < ActiveRecord::Migration[5.1]
  def change
    add_column :survey_api_targets, :api_filter_payout_cents, :integer, null: false
  end
end
