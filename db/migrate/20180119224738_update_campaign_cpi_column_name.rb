# frozen_string_literal: true

class UpdateCampaignCpiColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :campaigns, :cpi_cemts, :cpi_cents
  end
end
