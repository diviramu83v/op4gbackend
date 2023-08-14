# frozen_string_literal: true

class AddOriginalDonationPercentageToPanelist < ActiveRecord::Migration[5.1]
  def change
    rename_column :panelists, :nonprofit_contribution_percentage, :donation_percentage
    add_column :panelists, :original_donation_percentage, :integer, null: false, default: 0
  end
end
